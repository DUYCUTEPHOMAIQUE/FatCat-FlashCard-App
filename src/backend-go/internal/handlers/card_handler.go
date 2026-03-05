package handlers

import (
	"strconv"

	"fatcat-backend/internal/services"

	"github.com/gin-gonic/gin"
)

// GetCardsByDeckID godoc
// GET /v1/api/card/:deck_id
func GetCardsByDeckID(c *gin.Context) {
	deckIDStr := c.Param("deck_id")
	deckID, _ := strconv.ParseUint(deckIDStr, 10, 64)

	cards, err := services.GetCardsByDeckID(uint(deckID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get cards by deck id successfully", cards)
}
