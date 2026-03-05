package services

import (
	"errors"
	"fmt"
	"time"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type RegisterInput struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
	Name     string `json:"name" binding:"required"`
}

type LoginInput struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type RegisterResult struct {
	Email      string `json:"email"`
	Name       string `json:"name"`
	RoleSystem string `json:"role_system"`
	OtpCode    string `json:"otpCode"`
}

type LoginResult struct {
	Email       string `json:"email"`
	Name        string `json:"name"`
	RoleSystem  string `json:"role_system"`
	AccessToken string `json:"accessToken"`
}

func Register(email, password, name string) (*RegisterResult, error) {
	if email == "" || password == "" || name == "" {
		return nil, fmt.Errorf("missing required fields")
	}

	var existing models.User
	if err := config.DB.Where("email = ?", email).First(&existing).Error; err == nil {
		return nil, fmt.Errorf("this email address is already associated with another account")
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(password), 10)
	if err != nil {
		return nil, err
	}

	user := models.User{
		Email:    email,
		Password: string(hashed),
		Name:     name,
	}
	if err := config.DB.Create(&user).Error; err != nil {
		return nil, err
	}

	otpCode, err := CreateOtpForUser(user.ID)
	if err != nil {
		return nil, err
	}

	go SendVerificationMail(user.Email, user.Name, otpCode)

	return &RegisterResult{
		Email:      user.Email,
		Name:       user.Name,
		RoleSystem: user.RoleSystem,
		OtpCode:    otpCode,
	}, nil
}

func VerifyAccount(email, otpCode string) (*LoginResult, error) {
	var user models.User
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, fmt.Errorf("user not found. please check the information and try again")
	}
	if user.IsVerified {
		return nil, &AppError{Message: "your account has already been verified", Code: 430}
	}

	var otp models.OTP
	if err := config.DB.Where("user_id = ? AND otp_code = ?", user.ID, otpCode).First(&otp).Error; err != nil {
		return nil, &AppError{Message: "the verification code is invalid. please double-check and try again", Code: 431}
	}

	if time.Now().After(otp.ExpiresAt) {
		return nil, &AppError{Message: "the verification code has expired. please request a new code", Code: 432}
	}

	config.DB.Model(&otp).Update("is_used", true)
	config.DB.Model(&user).Update("is_verified", true)

	accessToken, err := GenerateAccessToken(user.ID, user.Email, user.RoleSystem)
	if err != nil {
		return nil, err
	}

	// Decode expiry from token
	claims, _ := VerifyAccessToken(accessToken)
	tokenRecord := models.Token{
		UserID:      user.ID,
		AccessToken: accessToken,
		ExpiresAt:   claims.ExpiresAt.Time,
	}
	config.DB.Create(&tokenRecord)

	return &LoginResult{
		Email:       user.Email,
		Name:        user.Name,
		RoleSystem:  user.RoleSystem,
		AccessToken: accessToken,
	}, nil
}

func ResendCode(email string) (string, error) {
	var user models.User
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return "", fmt.Errorf("email is not correct")
	}
	if user.IsVerified {
		return "", &AppError{Message: "your account has already been verified", Code: 430}
	}
	newOtpCode, err := CreateOtpForUser(user.ID)
	if err != nil {
		return "", err
	}
	go SendVerificationMail(user.Email, user.Name, newOtpCode)
	return newOtpCode, nil
}

func Login(email, password string) (*LoginResult, error) {
	var user models.User
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, fmt.Errorf("email or password is not correct")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return nil, fmt.Errorf("email or password is not correct")
	}

	if !user.IsVerified {
		return nil, &AppError{Message: "your email has not been verified. please click on resend", Code: 405}
	}

	accessToken, err := GenerateAccessToken(user.ID, user.Email, user.RoleSystem)
	if err != nil {
		return nil, err
	}

	claims, _ := VerifyAccessToken(accessToken)
	tokenRecord := models.Token{
		UserID:      user.ID,
		AccessToken: accessToken,
		ExpiresAt:   claims.ExpiresAt.Time,
	}
	config.DB.Create(&tokenRecord)

	return &LoginResult{
		Email:       user.Email,
		Name:        user.Name,
		RoleSystem:  user.RoleSystem,
		AccessToken: accessToken,
	}, nil
}

func Logout(userID uint, accessToken string) error {
	return config.DB.Where("user_id = ? AND access_token = ?", userID, accessToken).Delete(&models.Token{}).Error
}

func LogoutAllDevice(userID uint) error {
	return config.DB.Where("user_id = ?", userID).Delete(&models.Token{}).Error
}

func ResetPassword(email string) (string, error) {
	var user models.User
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return "", fmt.Errorf("user not found")
	}

	LogoutAllDevice(user.ID)

	newPassword := GenerateRandomString(10)
	hashed, err := bcrypt.GenerateFromPassword([]byte(newPassword), 10)
	if err != nil {
		return "", err
	}
	config.DB.Model(&user).Update("password", string(hashed))
	go SendResetPasswordMail(user.Email, user.Name, newPassword)
	return newPassword, nil
}

func ChangePassword(userID uint, oldPassword, newPassword, accessToken string) error {
	var user models.User
	if err := config.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		return fmt.Errorf("user not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(oldPassword)); err != nil {
		return &AppError{Message: "your password is not correct. check and try again", Code: 400}
	}

	// Logout other devices
	config.DB.Where("user_id = ? AND access_token != ?", userID, accessToken).Delete(&models.Token{})

	hashed, err := bcrypt.GenerateFromPassword([]byte(newPassword), 10)
	if err != nil {
		return err
	}
	config.DB.Model(&user).Update("password", string(hashed))
	go SendSuccessResetPasswordEmail(user.Email, user.Name)
	return nil
}

// AppError is a custom error with HTTP status code
type AppError struct {
	Message string
	Code    int
}

func (e *AppError) Error() string {
	return e.Message
}

// IsNotFound checks if error is gorm not found
func IsNotFound(err error) bool {
	return errors.Is(err, gorm.ErrRecordNotFound)
}
