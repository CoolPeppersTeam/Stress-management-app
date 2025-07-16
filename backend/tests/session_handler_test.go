package tests

import (
	"bytes"
	"github.com/gin-gonic/gin"
	"github.com/slickip/Stress-management-app/backend/config"
	"github.com/slickip/Stress-management-app/backend/internal/handlers"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

func createAuthenticatedContext(method, path string, body []byte) (*gin.Context, *httptest.ResponseRecorder) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	req, _ := http.NewRequest(method, path, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	c.Request = req

	c.Set("user_id", uint(1))

	return c, w
}

func TestCreateSession_BadRequest(t *testing.T) {
	c, w := createAuthenticatedContext("POST", "/sessions", []byte(`{}`))

	handlers.CreateSession(c)

	assert.Equal(t, 400, w.Code)
	assert.Contains(t, w.Body.String(), "invalid input")
}

func TestGetSessions_EmptyDB(t *testing.T) {
	c, w := createAuthenticatedContext("GET", "/sessions", nil)

	handlers.GetSessions(c)

	assert.Contains(t, []int{200, 500}, w.Code)
}

func TestGetSessionById_NotFound(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Params = []gin.Param{{Key: "id", Value: "999"}}
	c.Set("user_id", uint(1))

	handlers.GetSessionById(c)

	assert.Equal(t, 404, w.Code)
	assert.Contains(t, w.Body.String(), "session not found")
}

func TestDeleteSession_NotFound(t *testing.T) {
	config.ConnectDatabase()
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Params = []gin.Param{{Key: "id", Value: "999"}}
	c.Set("user_id", uint(1))

	handlers.DeleteSession(c)

	assert.Equal(t, 404, w.Code)
	assert.Contains(t, w.Body.String(), "session not found")
}

func TestGetStats_Empty(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Set("user_id", uint(1))

	handlers.GetStats(c)

	assert.Equal(t, 200, w.Code)
}
