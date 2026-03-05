package handlers

import (
	"net/http"
	"strconv"

	"fatcat-backend/internal/services"

	"github.com/gin-gonic/gin"
)

// GetAllDecks godoc
// GET /v1/api/deck
func GetAllDecks(c *gin.Context) {
	data, err := services.GetAllDecks()
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get all decks successfully.", data)
}

// GetDecksByCategoryName godoc
// GET /v1/api/deck/category?categoryName=...
func GetDecksByCategoryName(c *gin.Context) {
	categoryName := c.Query("categoryName")
	data, err := services.GetDecksByCategoryName(categoryName)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get decks by category name successfully", data)
}

// CreateDeck godoc
// POST /v1/api/deck (auth required)
func CreateDeck(c *gin.Context) {
	userID := c.GetUint("userId")
	var body struct {
		Deck  map[string]interface{}  `json:"deck"`
		Cards []services.CardInput    `json:"Cards"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	// Cards can also be nested in deck
	cards := body.Cards
	if nestedCards, ok := body.Deck["Cards"]; ok {
		if cardList, ok := nestedCards.([]interface{}); ok && len(cards) == 0 {
			for _, item := range cardList {
				if m, ok := item.(map[string]interface{}); ok {
					card := services.CardInput{
						Question: getString(m, "question"),
						Answer:   getString(m, "answer"),
					}
					if id, ok := m["id"]; ok {
						card.ID = id
					}
					cards = append(cards, card)
				}
			}
		}
	}

	deck, err := services.CreateDeck(body.Deck, cards, userID)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Create new deck successfully.", gin.H{"deck": deck})
}

// UpdateDeck godoc
// PUT /v1/api/deck/:deckId (auth required)
func UpdateDeck(c *gin.Context) {
	userID := c.GetUint("userId")
	deckIDStr := c.Param("deckId")
	deckID, _ := strconv.ParseUint(deckIDStr, 10, 64)

	var body struct {
		Deck  map[string]interface{} `json:"deck"`
		Cards []services.CardInput   `json:"Cards"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	cards := body.Cards
	if nestedCards, ok := body.Deck["Cards"]; ok {
		if cardList, ok := nestedCards.([]interface{}); ok && len(cards) == 0 {
			for _, item := range cardList {
				if m, ok := item.(map[string]interface{}); ok {
					card := services.CardInput{
						Question: getString(m, "question"),
						Answer:   getString(m, "answer"),
					}
					if id, ok := m["id"]; ok {
						card.ID = id
					}
					cards = append(cards, card)
				}
			}
		}
	}

	result, err := services.UpdateDeck(body.Deck, cards, uint(deckID), userID)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Update deck successfully.", result)
}

// DeleteDeck godoc
// DELETE /v1/api/deck/:deckId (auth required)
func DeleteDeck(c *gin.Context) {
	userID := c.GetUint("userId")
	deckIDStr := c.Param("deckId")
	deckID, _ := strconv.ParseUint(deckIDStr, 10, 64)

	if err := services.DeleteDeck(uint(deckID), userID); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Delete deck successfully.", nil)
}

// GetDeckByDeckID godoc
// GET /v1/api/deck/:deckId (auth required)
func GetDeckByDeckID(c *gin.Context) {
	viewerID := c.GetUint("userId")
	deckIDStr := c.Param("deckId")
	deckID, _ := strconv.ParseUint(deckIDStr, 10, 64)

	deck, err := services.GetDeckByDeckID(viewerID, uint(deckID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get deck by deck id successfully.", gin.H{"deck": deck})
}

// GetDeckByUserID godoc
// GET /v1/api/deck/user/:userId (auth required)
func GetDeckByUserID(c *gin.Context) {
	viewerID := c.GetUint("userId")
	authorIDStr := c.Param("userId")
	authorID, _ := strconv.ParseUint(authorIDStr, 10, 64)

	decks, err := services.GetDeckByUserID(viewerID, uint(authorID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get all deck by userid successfully", gin.H{"deck": decks})
}

// CreateDeckByCopy godoc
// POST /v1/api/deck/:deckId/copy (auth required)
func CreateDeckByCopy(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "Copy deck feature not implemented"})
}

func getString(m map[string]interface{}, key string) string {
	if v, ok := m[key].(string); ok {
		return v
	}
	return ""
}
