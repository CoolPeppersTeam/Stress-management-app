package config

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/slickip/Stress-management-app/backend/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	// Попытка загрузить .env (если он есть)
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ .env file not loaded, relying on system environment variables")
	} else {
		log.Println("✅ .env file loaded successfully")
	}

	// Читаем конфигурацию из окружения
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")

	// Формируем DSN по переменным окружения
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname,
	)
	log.Printf("Connecting to database with DSN: %s", dsn)

	// Открываем соединение
	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Миграции
	if err := DB.AutoMigrate(
		&models.User{},
		&models.StressSession{},
		&models.Recommendation{},
	); err != nil {
		log.Fatalf("AutoMigrate failed: %v", err)
	}
}
