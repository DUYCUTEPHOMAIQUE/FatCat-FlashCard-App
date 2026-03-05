package main

import (
	"log"
	"net/http"
	"os"

	"fatcat-backend/internal/config"
	"fatcat-backend/router"

	"github.com/joho/godotenv"
	"github.com/robfig/cron/v3"
)

func main() {
	// Load .env
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	// Connect to database
	config.ConnectDatabase()

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "3056"
	}

	r := router.SetupRouter()

	// Cron job: ping server every 5 minutes to keep alive
	serverURL := os.Getenv("SERVER_URL")
	if serverURL == "" {
		serverURL = "https://fatcat-flashcard-app.onrender.com/v1/api/"
	}
	c := cron.New()
	c.AddFunc("*/5 * * * *", func() {
		resp, err := http.Get(serverURL)
		if err != nil {
			log.Printf("Error pinging server: %v", err)
			return
		}
		defer resp.Body.Close()
		log.Printf("Ping server response: %d", resp.StatusCode)
	})
	c.Start()
	log.Println("Cron job initialized - Server will be pinged every 5 minutes")

	log.Printf("Server is running on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
