package tests

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/ai"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestGetAdvice_Success(t *testing.T) {
	ai.SetupAI()
	config.ConnectDatabase()
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	jsonBody := []byte(`{
		"description": "I'm very stressed about exams",
		"stress_level": 8,
		"date": "2025-07-15T12:00:00Z"
	}`)
	req, _ := http.NewRequest("POST", "/ai/advice", bytes.NewBuffer(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	c.Request = req

	ai.GetAdvice(c)

	assert.Equal(t, 200, w.Code)
}

func TestGetAdvice_BadRequest(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	req, _ := http.NewRequest("POST", "/ai/advice", bytes.NewBuffer([]byte(`{}`)))
	req.Header.Set("Content-Type", "application/json")
	c.Request = req

	ai.GetAdvice(c)

	assert.Equal(t, 400, w.Code)
	assert.Contains(t, w.Body.String(), "Invalid input body")
}
