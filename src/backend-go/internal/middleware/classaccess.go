package middleware

import (
	"net/http"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"

	"github.com/gin-gonic/gin"
)

func IsMemberOfClass() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID := c.GetUint("userId")
		classID := c.Param("class_id")

		if userID == 0 || classID == "" {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"message": "Missing required parameters"})
			return
		}

		var member models.ClassMember
		if err := config.DB.Where("user_id = ? AND class_id = ?", userID, classID).First(&member).Error; err != nil {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"message": "You are not a member of this class"})
			return
		}

		c.Set("memberRole", member.Role)
		c.Next()
	}
}

func IsHostOfClass() gin.HandlerFunc {
	return func(c *gin.Context) {
		role, _ := c.Get("memberRole")
		if role != "host" {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"message": "Only manager can perform this action"})
			return
		}
		c.Next()
	}
}

func CanManageDeck() gin.HandlerFunc {
	return func(c *gin.Context) {
		role, _ := c.Get("memberRole")
		if c.Request.Method != "GET" && role != "manager" && role != "host" {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"message": "You don't have permission to manage decks"})
			return
		}
		c.Next()
	}
}
