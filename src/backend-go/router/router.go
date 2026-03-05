package router

import (
	"fatcat-backend/internal/handlers"
	"fatcat-backend/internal/middleware"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// CORS
	r.Use(cors.Default())

	// Health check
	r.GET("/v1/api", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Welcome to the API"})
	})

	// Access routes (auth)
	access := r.Group("/v1/api/access")
	{
		access.POST("/register", handlers.Register)
		access.POST("/verify-account", handlers.VerifyAccount)
		access.POST("/resend-code", handlers.ResendCode)
		access.POST("/login", handlers.Login)
		access.POST("/logout", middleware.AuthenticateToken(), handlers.Logout)
		access.POST("/logout-all-device", middleware.AuthenticateToken(), handlers.LogoutAllDevice)
		access.POST("/reset-password", handlers.ResetPassword)
		access.POST("/change-password", middleware.AuthenticateToken(), handlers.ChangePassword)
	}

	// Deck routes
	deck := r.Group("/v1/api/deck")
	{
		deck.GET("/", handlers.GetAllDecks)
		deck.GET("/category", handlers.GetDecksByCategoryName)
		deck.POST("/", middleware.AuthenticateToken(), handlers.CreateDeck)
		deck.PUT("/:deckId", middleware.AuthenticateToken(), handlers.UpdateDeck)
		deck.DELETE("/:deckId", middleware.AuthenticateToken(), handlers.DeleteDeck)
		deck.POST("/:deckId/copy", middleware.AuthenticateToken(), handlers.CreateDeckByCopy)
		deck.GET("/user/:userId", middleware.AuthenticateToken(), handlers.GetDeckByUserID)
		deck.GET("/:deckId", middleware.AuthenticateToken(), handlers.GetDeckByDeckID)
	}

	// Card routes
	card := r.Group("/v1/api/card")
	{
		card.GET("/:deck_id", handlers.GetCardsByDeckID)
	}

	// Class routes (all auth required)
	class := r.Group("/v1/api/class", middleware.AuthenticateToken())
	{
		class.GET("/", handlers.GetAllClasses)
		class.GET("/own_classes", handlers.GetClassByUserID)
		class.GET("/:class_id/members", handlers.GetMembersOfClass)
		class.GET("/:class_id/decks", handlers.GetDeckForClass)
		class.POST("/", handlers.CreateClass)
		class.POST("/:code_invite", handlers.JoinClass)
		class.DELETE("/:class_id", handlers.DeleteClass)
		class.DELETE("/:class_id/members/:user_id", handlers.DeleteMember)
		class.DELETE("/leave/:class_id", handlers.LeaveClass)
		class.PATCH("/:class_id", handlers.UpdateClass)
		class.POST("/:class_id/decks", handlers.CreateDeckForClass)
		class.PATCH("/:class_id/decks/:deck_id", middleware.CanManageDeck(), handlers.UpdateDeckForClass)
	}

	// 404 handler
	r.NoRoute(func(c *gin.Context) {
		c.JSON(404, gin.H{"status": 404, "message": "Not found"})
	})

	return r
}
