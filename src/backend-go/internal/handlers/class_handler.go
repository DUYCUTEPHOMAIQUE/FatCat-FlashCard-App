package handlers

import (
	"net/http"
	"strconv"

	"fatcat-backend/internal/services"

	"github.com/gin-gonic/gin"
)

// CreateClass godoc
// POST /v1/api/class (auth required)
func CreateClass(c *gin.Context) {
	userID := c.GetUint("userId")
	var body struct {
		Name        string `json:"name"`
		Description string `json:"description"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	result, err := services.CreateClass(body.Name, body.Description, userID)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Create class successfully", result)
}

// GetAllClasses godoc
// GET /v1/api/class (auth required)
func GetAllClasses(c *gin.Context) {
	classes, err := services.GetAllClasses()
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get all classes successfully", classes)
}

// GetClassByUserID godoc
// GET /v1/api/class/own_classes (auth required)
func GetClassByUserID(c *gin.Context) {
	userID := c.GetUint("userId")
	sortBy := c.Query("sortBy")
	classes, err := services.GetClassesByUserID(userID, sortBy)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get class by user id successfully", classes)
}

// JoinClass godoc
// POST /v1/api/class/:code_invite (auth required)
func JoinClass(c *gin.Context) {
	userID := c.GetUint("userId")
	codeInvite := c.Param("code_invite")
	result, err := services.JoinClass(userID, codeInvite)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Join class successfully", result)
}

// LeaveClass godoc
// DELETE /v1/api/class/leave/:class_id (auth required)
func LeaveClass(c *gin.Context) {
	userID := c.GetUint("userId")
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	if err := services.LeaveClass(userID, uint(classID)); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Leave class successfully", nil)
}

// DeleteClass godoc
// DELETE /v1/api/class/:class_id (auth required)
func DeleteClass(c *gin.Context) {
	userID := c.GetUint("userId")
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	if err := services.DeleteClass(uint(classID), userID); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Delete class successfully", nil)
}

// UpdateClass godoc
// PATCH /v1/api/class/:class_id (auth required)
func UpdateClass(c *gin.Context) {
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	var body struct {
		Name        string `json:"name"`
		Description string `json:"description"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	if err := services.UpdateClass(uint(classID), body.Name, body.Description); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Update class successfully", nil)
}

// GetMembersOfClass godoc
// GET /v1/api/class/:class_id/members (auth required)
func GetMembersOfClass(c *gin.Context) {
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	result, err := services.GetMembers(uint(classID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get members of class successfully", result)
}

// DeleteMember godoc
// DELETE /v1/api/class/:class_id/members/:user_id (auth required)
func DeleteMember(c *gin.Context) {
	hostUserID := c.GetUint("userId")
	classIDStr := c.Param("class_id")
	userIDStr := c.Param("user_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	userID, _ := strconv.ParseUint(userIDStr, 10, 64)
	if err := services.DeleteMember(uint(userID), uint(classID), hostUserID); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Delete member successfully", nil)
}

// CreateDeckForClass godoc
// POST /v1/api/class/:class_id/decks (auth required)
func CreateDeckForClass(c *gin.Context) {
	userID := c.GetUint("userId")
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)

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

	deck, err := services.CreateDeckForClass(body.Deck, cards, userID, uint(classID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Create deck for class successfully", deck)
}

// GetDeckForClass godoc
// GET /v1/api/class/:class_id/decks (auth required)
func GetDeckForClass(c *gin.Context) {
	classIDStr := c.Param("class_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	decks, err := services.GetDeckForClass(uint(classID))
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Get decks for class successfully", decks)
}

// UpdateDeckForClass godoc
// PATCH /v1/api/class/:class_id/decks/:deck_id (auth required)
func UpdateDeckForClass(c *gin.Context) {
	userID := c.GetUint("userId")
	classIDStr := c.Param("class_id")
	deckIDStr := c.Param("deck_id")
	classID, _ := strconv.ParseUint(classIDStr, 10, 64)
	deckID, _ := strconv.ParseUint(deckIDStr, 10, 64)

	var body struct {
		Deck  map[string]interface{} `json:"deck"`
		Cards []services.CardInput   `json:"Cards"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	result, err := services.UpdateDeckForClass(uint(classID), uint(deckID), body.Deck, body.Cards, userID)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Update deck for class successfully", result)
}
