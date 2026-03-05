package services

import (
	"fmt"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
)

type DeckData struct {
	ID               uint        `json:"id"`
	Name             string      `json:"name"`
	Description      string      `json:"description"`
	UserID           uint        `json:"user_id"`
	UserName         string      `json:"user_name"`
	CategoryID       *uint       `json:"category_id"`
	DeckCardsCount   int         `json:"deck_cards_count"`
	IsPublished      bool        `json:"is_published"`
	CategoryName     string      `json:"category_name"`
	QuestionLanguage string      `json:"question_language"`
	AnswerLanguage   string      `json:"answer_language"`
	CreatedAt        interface{} `json:"created_at"`
	UpdatedAt        interface{} `json:"updated_at"`
}

func GetAllDecks() ([]DeckData, error) {
	var decks []models.Deck
	if err := config.DB.Preload("Category").Preload("User").Find(&decks).Error; err != nil {
		return nil, err
	}
	data := make([]DeckData, len(decks))
	for i, deck := range decks {
		d := DeckData{
			ID:               deck.ID,
			Name:             deck.Name,
			Description:      deck.Description,
			UserID:           deck.UserID,
			CategoryID:       deck.CategoryID,
			DeckCardsCount:   deck.DeckCardsCount,
			IsPublished:      deck.IsPublished,
			QuestionLanguage: deck.QuestionLanguage,
			AnswerLanguage:   deck.AnswerLanguage,
			CreatedAt:        deck.CreatedAt,
			UpdatedAt:        deck.UpdatedAt,
		}
		if deck.User != nil {
			d.UserName = deck.User.Name
		}
		if deck.Category != nil {
			d.CategoryName = deck.Category.Name
		}
		data[i] = d
	}
	return data, nil
}

func GetDecksByCategoryName(categoryName string) ([]DeckData, error) {
	var category models.Category
	if err := config.DB.Where("name = ?", categoryName).First(&category).Error; err != nil {
		return nil, fmt.Errorf("category not found")
	}
	var decks []models.Deck
	if err := config.DB.Where("category_id = ?", category.ID).Preload("Category").Find(&decks).Error; err != nil {
		return nil, err
	}
	data := make([]DeckData, len(decks))
	for i, deck := range decks {
		d := DeckData{
			ID:               deck.ID,
			Name:             deck.Name,
			Description:      deck.Description,
			UserID:           deck.UserID,
			CategoryID:       deck.CategoryID,
			DeckCardsCount:   deck.DeckCardsCount,
			IsPublished:      deck.IsPublished,
			QuestionLanguage: deck.QuestionLanguage,
			AnswerLanguage:   deck.AnswerLanguage,
			CreatedAt:        deck.CreatedAt,
			UpdatedAt:        deck.UpdatedAt,
		}
		if deck.Category != nil {
			d.CategoryName = deck.Category.Name
		}
		data[i] = d
	}
	return data, nil
}

func GetUserInfo(userID uint) (map[string]interface{}, error) {
	var user models.User
	if err := config.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		return nil, fmt.Errorf("user not found")
	}
	return map[string]interface{}{
		"username": user.Name,
		"avatar":   user.Avatar,
	}, nil
}

type CreateDeckInput struct {
	Deck  map[string]interface{} `json:"deck"`
	Cards []CardInput            `json:"Cards"`
}

type CardInput struct {
	ID       interface{} `json:"id"`
	Question string      `json:"question"`
	Answer   string      `json:"answer"`
	Image    []byte      `json:"image"`
	DeckID   uint        `json:"deck_id"`
}

func CreateDeck(deckInput map[string]interface{}, cards []CardInput, userID uint) (*models.Deck, error) {
	// Build deck from input
	deck := models.Deck{
		UserID:         userID,
		DeckCardsCount: len(cards),
	}
	if v, ok := deckInput["name"].(string); ok {
		deck.Name = v
	}
	if v, ok := deckInput["description"].(string); ok {
		deck.Description = v
	}
	if v, ok := deckInput["is_published"].(bool); ok {
		deck.IsPublished = v
	} else {
		deck.IsPublished = true
	}
	if v, ok := deckInput["question_language"].(string); ok {
		deck.QuestionLanguage = v
	}
	if v, ok := deckInput["answer_language"].(string); ok {
		deck.AnswerLanguage = v
	}
	if v, ok := deckInput["category_id"].(float64); ok {
		catID := uint(v)
		deck.CategoryID = &catID
	}

	// Build cards
	gormCards := make([]models.Card, len(cards))
	for i, c := range cards {
		gormCards[i] = models.Card{
			Question: c.Question,
			Answer:   c.Answer,
			Image:    c.Image,
		}
	}
	deck.Cards = gormCards

	if err := config.DB.Create(&deck).Error; err != nil {
		return nil, err
	}
	return &deck, nil
}

func GetDeckByDeckID(viewerID uint, deckID uint) (*models.Deck, error) {
	var deck models.Deck
	if err := config.DB.Preload("Cards").Where("id = ?", deckID).First(&deck).Error; err != nil {
		return nil, &AppError{Message: "deck not found", Code: 404}
	}
	if viewerID != deck.UserID && !deck.IsPublished {
		return nil, &AppError{Message: "this deck is private. access denied", Code: 403}
	}
	return &deck, nil
}

type UpdateDeckInput struct {
	Deck  map[string]interface{} `json:"deck"`
	Cards []CardInput            `json:"Cards"`
}

func UpdateDeck(deckInput map[string]interface{}, cards []CardInput, deckID uint, userID uint) (map[string]interface{}, error) {
	if deckInput == nil {
		return nil, &AppError{Message: "deck is required in request", Code: 400}
	}

	// Verify deckId matches
	if idVal, ok := deckInput["id"].(float64); ok {
		if uint(idVal) != deckID {
			return nil, &AppError{Message: "something went wrong. try again later", Code: 400}
		}
	}

	var existingDeck models.Deck
	if err := config.DB.Where("id = ?", deckID).First(&existingDeck).Error; err != nil {
		return nil, &AppError{Message: "deck not found", Code: 404}
	}

	// Update deck fields
	updates := map[string]interface{}{}
	if v, ok := deckInput["name"].(string); ok {
		updates["name"] = v
	}
	if v, ok := deckInput["description"].(string); ok {
		updates["description"] = v
	}
	if v, ok := deckInput["is_published"].(bool); ok {
		updates["is_published"] = v
	}
	if v, ok := deckInput["question_language"].(string); ok {
		updates["question_language"] = v
	}
	if v, ok := deckInput["answer_language"].(string); ok {
		updates["answer_language"] = v
	}
	if v, ok := deckInput["category_id"].(float64); ok {
		updates["category_id"] = uint(v)
	}

	if len(updates) > 0 {
		config.DB.Model(&existingDeck).Updates(updates)
	}

	// Sync cards
	if err := syncCards(deckID, cards); err != nil {
		return nil, err
	}

	// Get updated cards
	var newCards []models.Card
	config.DB.Where("deck_id = ?", deckID).Find(&newCards)

	// Update card count
	config.DB.Model(&existingDeck).Update("deck_cards_count", len(newCards))

	return map[string]interface{}{
		"deck": map[string]interface{}{
			"id":                existingDeck.ID,
			"name":              existingDeck.Name,
			"description":       existingDeck.Description,
			"user_id":           existingDeck.UserID,
			"category_id":       existingDeck.CategoryID,
			"is_published":      existingDeck.IsPublished,
			"deck_cards_count":  len(newCards),
			"question_language": existingDeck.QuestionLanguage,
			"answer_language":   existingDeck.AnswerLanguage,
			"Cards":             newCards,
		},
	}, nil
}

func syncCards(deckID uint, cards []CardInput) error {
	// Get existing card IDs
	var existingCards []models.Card
	config.DB.Where("deck_id = ?", deckID).Find(&existingCards)

	existingIDs := make(map[uint]bool)
	for _, c := range existingCards {
		existingIDs[c.ID] = true
	}

	var toCreate []models.Card
	var toUpdate []models.Card
	requestIDs := make(map[uint]bool)

	for _, c := range cards {
		var idVal uint
		switch v := c.ID.(type) {
		case float64:
			idVal = uint(v)
		case string:
			if v == "" {
				idVal = 0
			}
		}

		if idVal == 0 {
			// Create new card
			toCreate = append(toCreate, models.Card{
				DeckID:   deckID,
				Question: c.Question,
				Answer:   c.Answer,
				Image:    c.Image,
			})
		} else {
			requestIDs[idVal] = true
			toUpdate = append(toUpdate, models.Card{
				ID:       idVal,
				Question: c.Question,
				Answer:   c.Answer,
				Image:    c.Image,
			})
		}
	}

	// Find IDs to delete
	var toDeleteIDs []uint
	for id := range existingIDs {
		if !requestIDs[id] {
			toDeleteIDs = append(toDeleteIDs, id)
		}
	}

	// Delete
	if len(toDeleteIDs) > 0 {
		config.DB.Where("id IN ?", toDeleteIDs).Delete(&models.Card{})
	}

	// Create
	if len(toCreate) > 0 {
		config.DB.Create(&toCreate)
	}

	// Update
	for _, c := range toUpdate {
		config.DB.Model(&models.Card{}).Where("id = ?", c.ID).Updates(map[string]interface{}{
			"question": c.Question,
			"answer":   c.Answer,
			"image":    c.Image,
		})
	}

	return nil
}

func DeleteDeck(deckID uint, userID uint) error {
	var deck models.Deck
	if err := config.DB.Where("id = ?", deckID).First(&deck).Error; err != nil {
		return &AppError{Message: "deck not found", Code: 404}
	}
	if userID != deck.UserID {
		return &AppError{Message: "access denied", Code: 403}
	}
	return config.DB.Delete(&deck).Error
}

func GetDeckByUserID(viewerID uint, authorID uint) ([]models.Deck, error) {
	var decks []models.Deck
	if viewerID == authorID {
		config.DB.Where("user_id = ?", viewerID).Find(&decks)
	} else {
		config.DB.Where("user_id = ? AND is_published = ?", authorID, true).Find(&decks)
	}
	return decks, nil
}
