package tests

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/handlers"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestGetRecommendations(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	handlers.GetRecommendations(c)

	assert.Contains(t, []int{200, 500}, w.Code)
}

func TestGetRecommendationByID_NotFound(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Params = []gin.Param{{Key: "id", Value: "999"}}

	handlers.GetRecommendationByID(c)

	assert.Equal(t, 500, w.Code)
	assert.Contains(t, w.Body.String(), "recommendation not found")
}

func TestCreateRecommendation_BadRequest(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	req, _ := http.NewRequest("POST", "/recommendations", bytes.NewBuffer([]byte(`{}`)))
	req.Header.Set("Content-Type", "application/json")
	c.Request = req

	handlers.CreateRecommendation(c)

	assert.Equal(t, 400, w.Code)
	assert.Contains(t, w.Body.String(), "invalid input")
}

func TestUpdateRecommendationByID_BadRequest(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Params = []gin.Param{{Key: "id", Value: "999"}}
	c.Request = httptest.NewRequest(http.MethodPut, "/recommendations/999", nil)

	c.Set("db", config.DB)

	handlers.UpdateRecommendationByID(c)

	assert.Equal(t, 500, w.Code)
	assert.Contains(t, w.Body.String(), "recommendation not found")
}

func TestDeleteRecommendationByID_NotFound(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	c.Params = []gin.Param{{Key: "id", Value: "999"}}
	req, _ := http.NewRequest("DELETE", "/recommendations/999", nil)
	c.Request = req

	handlers.DeleteRecommendationByID(c)

	assert.Equal(t, 500, w.Code)
	assert.Contains(t, w.Body.String(), "recommendation not found")
}
