package services

import (
	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
)

func GetCardsByDeckID(deckID uint) ([]models.Card, error) {
	var cards []models.Card
	if err := config.DB.Where("deck_id = ?", deckID).Find(&cards).Error; err != nil {
		return nil, err
	}
	return cards, nil
}
