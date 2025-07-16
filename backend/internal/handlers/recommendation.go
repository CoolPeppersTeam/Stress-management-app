package handlers

import (
	"net/http"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/models"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/config"
	"github.com/gin-gonic/gin"
)

type RecommendationInput struct {
	Title       string `json:"title" binding:"required"`
	Description string `json:"description" binding:"required"`
}

// GetRecommendations godoc
// @Summary Get all recommendations
// @Description Retrieve all recommendations from the database
// @Tags recommendations
// @Produce json
// @Router /recommendations [get]
func GetRecommendations(c *gin.Context) {
	var recs []models.Recommendation
	if err := config.DB.Find(&recs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения рекомендаций"})
		return
	}
	c.JSON(http.StatusOK, recs)
}

// GetRecommendationByID godoc
// @Summary Get a recommendation by ID
// @Description Retrieve a specific recommendation by its ID
// @Tags recommendations
// @Produce json
// @Param id path int true "Recommendation ID"
// @Router /recommendations/{id} [get]
func GetRecommendationByID(c *gin.Context) {
	recommendationID := c.Param("id")
	var recommendation models.Recommendation
	if err := config.DB.Where("id = ?", recommendationID).First(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "recommendation not found"})
		return
	}
	c.JSON(http.StatusOK, recommendation)
}

// CreateRecommendation godoc
// @Summary Create a new recommendation
// @Description Add a new recommendation entry
// @Tags recommendations
// @Accept json
// @Produce json
// @Param input body RecommendationInput true "Recommendation input"
// @Router /recommendations [post]
func CreateRecommendation(c *gin.Context) {
	var input RecommendationInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
		return
	}

	recommendation := models.Recommendation{
		Title:       input.Title,
		Description: input.Description,
	}
	if err := config.DB.Create(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "create recommendation error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "recommendation created"})
}

// UpdateRecommendationByID godoc
// @Summary Update recommendation by ID
// @Description Update title and description of a recommendation
// @Tags recommendations
// @Accept json
// @Produce json
// @Param id path int true "Recommendation ID"
// @Param input body models.Recommendation true "New recommendation content"
// @Router /recommendations/{id} [put]
func UpdateRecommendationByID(c *gin.Context) {
	recommendationID := c.Param("id")

	var recommendation models.Recommendation
	if err := config.DB.Where("id = ?", recommendationID).First(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "recommendation not found"})
		return
	}

	var newRecommendation models.Recommendation
	if err := c.ShouldBindJSON(&newRecommendation); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
	}

	recommendation.Title = newRecommendation.Title
	recommendation.Description = newRecommendation.Description
	if err := config.DB.Save(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "update recommendation error"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "recommendation updated"})
}

// DeleteRecommendationByID godoc
// @Summary Delete recommendation by ID
// @Description Delete a recommendation from the database
// @Tags recommendations
// @Produce json
// @Param id path int true "Recommendation ID"
func DeleteRecommendationByID(c *gin.Context) {
	recommendationID := c.Param("id")
	var recommendation models.Recommendation
	if err := config.DB.Where("id = ?", recommendationID).First(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "recommendation not found"})
		return
	}
	if err := config.DB.Delete(&recommendation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "delete recommendation error"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "recommendation was deleted"})
}

// GetStats godoc
// @Summary Get user session statistics
// @Description Get total session count and average stress level
// @Tags statistics
// @Produce json
// @Security BearerAuth
// @Router /stats [get]
func GetStats(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var count int64
	var total int64

	config.DB.Model(&models.StressSession{}).Where("user_id = ?", userID).Count(&count)
	config.DB.Model(&models.StressSession{}).Where("user_id = ?", userID).Select("COALESCE(SUM(stress_level), 0)").Scan(&total)

	var avg float64
	if count > 0 {
		avg = float64(total) / float64(count)
	}

	c.JSON(http.StatusOK, gin.H{
		"total_sessions": count,
		"average_stress": avg,
	})
}
