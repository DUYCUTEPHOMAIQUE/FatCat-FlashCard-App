package services

import (
	"fmt"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
)

func CreateDeckForClass(deckInput map[string]interface{}, cards []CardInput, userID uint, classID uint) (*models.Deck, error) {
	deck, err := CreateDeck(deckInput, cards, userID)
	if err != nil {
		return nil, err
	}

	classDeck := models.ClassDeck{
		ClassID: classID,
		DeckID:  deck.ID,
	}
	config.DB.Create(&classDeck)

	return deck, nil
}

func GetDeckForClass(classID uint) ([]map[string]interface{}, error) {
	var foundClass models.Class
	if err := config.DB.Where("id = ?", classID).First(&foundClass).Error; err != nil {
		return nil, fmt.Errorf("class not found")
	}

	var classDecks []models.ClassDeck
	config.DB.Where("class_id = ?", classID).Preload("Deck").Find(&classDecks)

	result := make([]map[string]interface{}, 0, len(classDecks))
	for _, cd := range classDecks {
		if cd.Deck == nil {
			continue
		}
		var user models.User
		config.DB.Where("id = ?", cd.Deck.UserID).First(&user)

		data := map[string]interface{}{
			"id":                cd.Deck.ID,
			"name":              cd.Deck.Name,
			"description":       cd.Deck.Description,
			"user_id":           cd.Deck.UserID,
			"user_name":         user.Name,
			"category_id":       cd.Deck.CategoryID,
			"is_published":      cd.Deck.IsPublished,
			"deck_cards_count":  cd.Deck.DeckCardsCount,
			"question_language": cd.Deck.QuestionLanguage,
			"answer_language":   cd.Deck.AnswerLanguage,
			"created_at":        cd.Deck.CreatedAt,
			"updated_at":        cd.Deck.UpdatedAt,
		}
		result = append(result, data)
	}
	return result, nil
}

func UpdateDeckForClass(classID uint, deckID uint, deckInput map[string]interface{}, cards []CardInput, userID uint) (map[string]interface{}, error) {
	return UpdateDeck(deckInput, cards, deckID, userID)
}
