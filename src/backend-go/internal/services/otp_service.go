package services

import (
	"fmt"
	"math/rand"
	"time"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
)

func GenerateOTPCode() string {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return fmt.Sprintf("%06d", 100000+r.Intn(900000))
}

func CreateOtpForUser(userID uint) (string, error) {
	otpCode := GenerateOTPCode()
	expiresAt := time.Now().Add(5 * time.Minute)
	otp := models.OTP{
		UserID:    userID,
		OtpCode:   otpCode,
		ExpiresAt: expiresAt,
	}
	if err := config.DB.Create(&otp).Error; err != nil {
		return "", err
	}
	return otpCode, nil
}

func GenerateRandomString(length int) string {
	const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	result := make([]byte, length)
	for i := range result {
		result[i] = charset[r.Intn(len(charset))]
	}
	return string(result)
}
