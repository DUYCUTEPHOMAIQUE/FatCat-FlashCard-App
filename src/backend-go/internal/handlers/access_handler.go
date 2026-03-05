package handlers

import (
	"net/http"

	"fatcat-backend/internal/services"

	"github.com/gin-gonic/gin"
)

func sendSuccess(c *gin.Context, message string, metadata interface{}) {
	c.JSON(http.StatusOK, gin.H{
		"message":          message,
		"statusCode":       200,
		"reasonStatusCode": "OK",
		"metadata":         metadata,
	})
}

func sendError(c *gin.Context, err error) {
	if appErr, ok := err.(*services.AppError); ok {
		c.JSON(appErr.Code, gin.H{
			"status":  appErr.Code,
			"message": appErr.Message,
		})
		return
	}
	c.JSON(http.StatusInternalServerError, gin.H{
		"status":  500,
		"message": err.Error(),
	})
}

// Register godoc
// POST /v1/api/access/register
func Register(c *gin.Context) {
	var body struct {
		Email    string `json:"email"`
		Password string `json:"password"`
		Name     string `json:"name"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	result, err := services.Register(body.Email, body.Password, body.Name)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Registration successful.", result)
}

// VerifyAccount godoc
// POST /v1/api/access/verify-account
func VerifyAccount(c *gin.Context) {
	var body struct {
		Email   string `json:"email"`
		OtpCode string `json:"otpCode"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	result, err := services.VerifyAccount(body.Email, body.OtpCode)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Account verification completed successfully.", result)
}

// ResendCode godoc
// POST /v1/api/access/resend-code
func ResendCode(c *gin.Context) {
	var body struct {
		Email string `json:"email"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	code, err := services.ResendCode(body.Email)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Verification code resent. Please check your email.", gin.H{"newOtpCode": code})
}

// Login godoc
// POST /v1/api/access/login
func Login(c *gin.Context) {
	var body struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	result, err := services.Login(body.Email, body.Password)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Welcome back! Login successful.", result)
}

// Logout godoc
// POST /v1/api/access/logout (auth required)
func Logout(c *gin.Context) {
	userID := c.GetUint("userId")
	accessToken := c.GetString("accessToken")
	if err := services.Logout(userID, accessToken); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Logout successful. See you again soon.", nil)
}

// LogoutAllDevice godoc
// POST /v1/api/access/logout-all-device (auth required)
func LogoutAllDevice(c *gin.Context) {
	userID := c.GetUint("userId")
	if err := services.LogoutAllDevice(userID); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Successfully logged out all device.", nil)
}

// ResetPassword godoc
// POST /v1/api/access/reset-password
func ResetPassword(c *gin.Context) {
	var body struct {
		Email string `json:"email"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	newPassword, err := services.ResetPassword(body.Email)
	if err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "A new password send to your email. Check your email.", gin.H{"newPassword": newPassword})
}

// ChangePassword godoc
// POST /v1/api/access/change-password (auth required)
func ChangePassword(c *gin.Context) {
	userID := c.GetUint("userId")
	accessToken := c.GetString("accessToken")
	var body struct {
		OldPassword string `json:"oldPassword"`
		NewPassword string `json:"newPassword"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	if err := services.ChangePassword(userID, body.OldPassword, body.NewPassword, accessToken); err != nil {
		sendError(c, err)
		return
	}
	sendSuccess(c, "Your password has been updated successfully.", nil)
}
