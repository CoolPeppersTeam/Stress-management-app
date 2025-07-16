package handlers

import (
	"log"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/internal/models"

	"gorm.io/gorm"
)

func SeedRecommendations(db *gorm.DB) {
	var count int64
	if err := db.Model(&models.Recommendation{}).Count(&count).Error; err != nil {
		log.Printf("Error checking recommendations count: %v", err)
		return
	}

	if count > 0 {
		log.Println("Recommendations already exist. Skipping seeding.")
		return
	}

	recommendations := []models.Recommendation{
		{
			Title:       "Deep Breathing Exercise",
			Description: "Try inhaling slowly for 4 seconds, holding for 4 seconds, and exhaling for 4 seconds.",
		},
		{
			Title:       "Take a Short Walk",
			Description: "A brief walk can help clear your mind and reduce stress.",
		},
		{
			Title:       "Mindfulness Meditation",
			Description: "Sit comfortably, close your eyes, and focus on your breath for 5 minutes.",
		},
	}

	if err := db.Create(&recommendations).Error; err != nil {
		log.Printf("Error seeding recommendations: %v", err)
	} else {
		log.Println("Seeded default recommendations.")
	}
}
