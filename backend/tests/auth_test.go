package tests

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/handlers"
	"github.com/gin-gonic/gin"
)

// setupRouter initializes the Gin engine with routes for testing
func setupRouter() *gin.Engine {
	config.ConnectDatabase()
	r := gin.Default()
	r.POST("/register", handlers.Register)
	r.POST("/login", handlers.Login)

	// Protected routes group
	protected := r.Group("/", handlers.AuthMiddleware())
	{
		protected.GET("/sessions", handlers.GetSessions)
	}
	return r
}

// TestRegister tests the user registration endpoint
func TestRegister(t *testing.T) {
	router := setupRouter()
	config.DB.Exec("DELETE FROM users WHERE email IN ('test@example.com', 'login@test.com')")
	body := `{
			"nickname": "TestUser",
			"email": "test@example.com",
			"password": "12345Ab"
	}`

	req, _ := http.NewRequest("POST", "/register", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusCreated {
		t.Errorf("Expected status 201, got %d", w.Code)
	}
}

// TestLogin tests successful login and token generation
func TestLogin(t *testing.T) {
	router := setupRouter()
	config.DB.Exec("DELETE FROM users WHERE email IN ('test@example.com', 'login@test.com')")
	registerBody := `{
  		"nickname": "LoginUser",
  		"email": "login@test.com",
  		"password": "12345A"
	}`
	req1, _ := http.NewRequest("POST", "/register", strings.NewReader(registerBody))
	req1.Header.Set("Content-Type", "application/json")
	w1 := httptest.NewRecorder()
	router.ServeHTTP(w1, req1)

	loginBody := `{
  		"email": "login@test.com",
  		"password": "12345A"
	}`
	req2, _ := http.NewRequest("POST", "/login", strings.NewReader(loginBody))
	req2.Header.Set("Content-Type", "application/json")
	w2 := httptest.NewRecorder()
	router.ServeHTTP(w2, req2)

	if w2.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", w2.Code)
	}

	var response map[string]string
	err := json.Unmarshal(w2.Body.Bytes(), &response)
	if err != nil || response["token"] == "" {
		t.Errorf("Token not found in response")
	}
}

// TestLoginWrongPassword ensures login fails with incorrect password
func TestLoginWrongPassword(t *testing.T) {
	router := setupRouter()
	// Register a user
	registerBody := `{
		"nickname": "WrongPass",
		"email": "wrong@test.com",
		"password": "Correct1"
	}`
	req1, _ := http.NewRequest("POST", "/register", strings.NewReader(registerBody))
	req1.Header.Set("Content-Type", "application/json")
	w1 := httptest.NewRecorder()
	router.ServeHTTP(w1, req1)

	// Attempt to login with wrong password
	loginBody := `{
		"email": "wrong@test.com",
		"password": "Incorrect!"
	}`
	req2, _ := http.NewRequest("POST", "/login", strings.NewReader(loginBody))
	req2.Header.Set("Content-Type", "application/json")
	w2 := httptest.NewRecorder()
	router.ServeHTTP(w2, req2)

	if w2.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d", w2.Code)
	}
}

// TestProtectedWithoutToken checks that /sessions requires authentication
func TestProtectedWithoutToken(t *testing.T) {
	router := setupRouter()

	req, _ := http.NewRequest("GET", "/sessions", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d", w.Code)
	}
}

// TestInvalidToken ensures access is denied with a fake token
func TestInvalidToken(t *testing.T) {
	router := setupRouter()

	req, _ := http.NewRequest("GET", "/sessions", nil)
	req.Header.Set("Authorization", "Bearer faketoken123")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d", w.Code)
	}
}
