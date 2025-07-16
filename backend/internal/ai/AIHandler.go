package ai

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/models"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/gin-gonic/gin"
)

type SessionInput struct {
	Description string    `json:"description" binding:"required"`
	StressLevel int       `json:"stress_level" binding:"required"`
	Date        time.Time `json:"date" binding:"required"`
}

// GetAdvice generates a short stress-reduction advice based on the user's input.
// @Summary      Generate AI-based advice
// @Description  Uses Gemini AI to provide short advice (max 20 words) based on description, stress level, and date
// @Tags         AI
// @Accept       json
// @Produce      json
// @Param input body SessionInput true "Session input"
// @Router       /ai/advice [post]
func GetAdvice(c *gin.Context) {
	var input SessionInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input body"})
		return
	}
	log.Printf("GetAdvice payload: %+v\n", input)
	var recommendation models.Recommendation
	promt := fmt.Sprintf("Description: %s \nStress Level: %d \nDate: %s \n"+
		"give me short advice for this problem. advice must be no more than 20 words.",
		input.Description, input.StressLevel, input.Date.String())

	// Если AI не отвечает — берём случайный совет из базы
	advice, err := newTextMessge(promt)
	if err != nil {
		// Если AI не отвечает — берём случайный совет из базы
		var recs []models.Recommendation
		err = config.DB.Find(&recs).Error
		if err != nil || len(recs) == 0 {
			recommendation.Description = "Рекомендация недоступна. Попробуйте позже."
			recommendation.Title = "AI недоступен"
			c.JSON(http.StatusOK, recommendation)
			return
		}
		randomIndex := time.Now().UnixNano() % int64(len(recs))
		recommendation = recs[randomIndex]
		c.JSON(http.StatusOK, recommendation)
		return
	}
	recommendation.Description = advice
	recommendation.Title = "advice from Gemini"
	if err := config.DB.Create(&recommendation).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, recommendation)
}
