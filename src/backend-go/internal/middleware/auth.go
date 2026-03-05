package middleware

import (
	"net/http"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
	"fatcat-backend/internal/services"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthenticateToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("authorization")
		if token == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"status":  401,
				"message": "Access denied. Authorization token missing from request.",
			})
			return
		}

		claims, err := services.VerifyAccessToken(token)
		if err != nil {
			status := 421
			if err == jwt.ErrTokenExpired {
				status = 420
			}
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"status":  status,
				"message": err.Error(),
			})
			return
		}

		// Check token exists in DB
		var tokenRecord models.Token
		if err := config.DB.Where("user_id = ? AND access_token = ?", claims.UserID, token).First(&tokenRecord).Error; err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"status":  402,
				"message": "Access denied. No valid session token. Please re-authenticate.",
			})
			return
		}

		c.Set("userId", claims.UserID)
		c.Set("email", claims.Email)
		c.Set("role", claims.Role)
		c.Set("accessToken", token)
		c.Next()
	}
}
