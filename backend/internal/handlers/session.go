package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/models"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/WebSocket"
	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/gin-gonic/gin"
)

type CreateSessionInput struct {
	Description string    `json:"description" binding:"required"`
	StressLevel int       `json:"stress_level" binding:"required"`
	Date        time.Time `json:"date" binding:"required"`
}

// CreateSession godoc
// @Summary Create a stress session
// @Description Create a new stress session for the authenticated user
// @Tags sessions
// @Accept json
// @Produce json
// @Param input body CreateSessionInput true "Session input"
// @Security BearerAuth
// @Router /sessions [post]
func CreateSession(c *gin.Context) {
	var input CreateSessionInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
		return
	}

	userID, _ := c.Get("user_id")

	session := models.StressSession{
		UserID:      userID.(uint),
		Description: input.Description,
		StressLevel: input.StressLevel,
		Date:        input.Date,
		CreatedAt:   time.Now(),
	}

	if err := config.DB.Create(&session).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "create session error"})
		return
	}

	c.JSON(http.StatusCreated, session)
}

// GetSessions godoc
// @Summary Get all stress sessions
// @Description Get all stress sessions for the authenticated user
// @Tags sessions
// @Produce json
// @Security BearerAuth
// @Router /sessions [get]
func GetSessions(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var sessions []models.StressSession
	if err := config.DB.Where("user_id = ?", userID).Order("date desc").Find(&sessions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "download sessions error"})
		return
	}

	c.JSON(http.StatusOK, sessions)
}

// GetSessionById godoc
// @Summary Get stress session by ID
// @Description Get a specific stress session by its ID (only if it belongs to the user)
// @Tags sessions
// @Produce json
// @Param id path int true "Session ID"
// @Security BearerAuth
// @Router /sessions/{id} [get]
func GetSessionById(c *gin.Context) {
	userID, _ := c.Get("user_id")
	sessionID := c.Param("id")

	var session models.StressSession
	if err := config.DB.Where("id = ? AND user_id = ?", sessionID, userID).First(&session).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "session not found"})
		return
	}

	c.JSON(http.StatusOK, session)
}

// DeleteSession godoc
// @Summary Delete stress session
// @Description Delete a stress session by its ID (only if it belongs to the user)
// @Tags sessions
// @Produce json
// @Param id path int true "Session ID"
// @Security BearerAuth
// @Router /sessions/{id} [delete]
func DeleteSession(c *gin.Context) {
	userID, _ := c.Get("user_id")
	id := c.Param("id")

	var session models.StressSession
	if err := config.DB.First(&session, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "session not found"})
		return
	}

	if session.UserID != userID.(uint) {
		c.JSON(http.StatusForbidden, gin.H{"error": "not authorized"})
		return
	}

	if err := config.DB.Delete(&session).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "delete session failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "delete session success"})
}

// CreateSessionWithWS godoc
// @Summary Create a session and broadcast via WebSocket
// @Description Create a new stress session and broadcast "new_session" event to all WebSocket clients
// @Tags sessions
// @Accept json
// @Produce json
// @Param input body CreateSessionInput true "Session input"
// @Security BearerAuth
// @Router /sessions [post]
func CreateSessionWithWS(hub *WebSocket.Hub) gin.HandlerFunc {
	return func(c *gin.Context) {
		var input CreateSessionInput
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Неверные данные"})
			return
		}

		userID, _ := c.Get("user_id")

		session := models.StressSession{
			UserID:      userID.(uint),
			Description: input.Description,
			StressLevel: input.StressLevel,
			Date:        input.Date,
			CreatedAt:   time.Now(),
		}

		if err := config.DB.Create(&session).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка создания"})
			return
		}

		jsonData, _ := json.Marshal(gin.H{
			"event":   "new_session",
			"session": session,
		})
		hub.Broadcast(jsonData)

		c.JSON(http.StatusCreated, session)
	}
}
