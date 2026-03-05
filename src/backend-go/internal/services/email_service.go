package services

import (
	"net/smtp"
	"os"
	"strings"
)

func getEnvOrDefault(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func sendMail(to, subject, body string) error {
	from := os.Getenv("EMAIL")
	pass := os.Getenv("PASSWORD")
	smtpHost := getEnvOrDefault("SMTP_HOST", "smtp.gmail.com")
	smtpPort := getEnvOrDefault("SMTP_PORT", "587")

	auth := smtp.PlainAuth("", from, pass, smtpHost)
	msg := "From: FatCat <" + from + ">\r\n" +
		"To: " + to + "\r\n" +
		"Subject: " + subject + "\r\n" +
		"MIME-version: 1.0;\r\nContent-Type: text/html; charset=\"UTF-8\";\r\n\r\n" +
		body
	return smtp.SendMail(smtpHost+":"+smtpPort, auth, from, []string{to}, []byte(msg))
}

func SendVerificationMail(email, name, otpCode string) error {
	html := verificationEmailTemplate(name, otpCode, "5", "FatCat")
	return sendMail(email, "Verify Your Account", html)
}

func SendResetPasswordMail(email, name, newPassword string) error {
	html := resetPasswordTemplate(name, newPassword)
	return sendMail(email, "Reset Password", html)
}

func SendSuccessResetPasswordEmail(email, name string) error {
	html := successResetPasswordTemplate(name)
	return sendMail(email, "Password Changed Successfully", html)
}

func verificationEmailTemplate(userName, verificationCode, expirationTime, appName string) string {
	tmpl := `<!DOCTYPE html>
<html>
<body>
<p>Hello {userName},</p>
<p>Your verification code for {appName} is: <strong>{verificationCode}</strong></p>
<p>This code will expire in {expirationTime} minutes.</p>
</body>
</html>`
	tmpl = strings.ReplaceAll(tmpl, "{userName}", userName)
	tmpl = strings.ReplaceAll(tmpl, "{verificationCode}", verificationCode)
	tmpl = strings.ReplaceAll(tmpl, "{expirationTime}", expirationTime)
	tmpl = strings.ReplaceAll(tmpl, "{appName}", appName)
	return tmpl
}

func resetPasswordTemplate(name, newPassword string) string {
	tmpl := `<!DOCTYPE html>
<html>
<body>
<p>Hello {User},</p>
<p>Your temporary password for FatCat is: <strong>{Your_Temporary_Password}</strong></p>
<p>Please change your password after logging in.</p>
<p>FatCat Team</p>
</body>
</html>`
	tmpl = strings.ReplaceAll(tmpl, "{User}", name)
	tmpl = strings.ReplaceAll(tmpl, "{Your_Temporary_Password}", newPassword)
	return tmpl
}

func successResetPasswordTemplate(name string) string {
	tmpl := `<!DOCTYPE html>
<html>
<body>
<p>Hello {User},</p>
<p>Your password for FatCat has been changed successfully.</p>
<p>FatCat Team</p>
</body>
</html>`
	tmpl = strings.ReplaceAll(tmpl, "{User}", name)
	return tmpl
}
