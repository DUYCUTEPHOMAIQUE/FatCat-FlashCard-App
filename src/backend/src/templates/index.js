const VERIFICATION_EMAIL_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
  <div style="background: linear-gradient(to right, #4CAF50, #45a049); padding: 20px; text-align: center;">
    <h1 style="color: white; margin: 0;">Verify Your Email</h1>
  </div>
  <div style="background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <p>Hello <b>{userName}</b>,</p>
    <p>Thank you for signing up! Your verification code is:</p>
    <div style="text-align: center; margin: 30px 0;">
      <span style="font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #4CAF50;">{verificationCode}</span>
    </div>
    <p>Enter this code on the verification page to complete your registration.</p>
    <p>This code will expire in <b>{expirationTime}</b> minutes for security reasons.</p>
    <p>If you didn't create an account with us, please ignore this email.</p>
    <p>Best regards,<br><b>{appName}</b></p>
  </div>
  <div style="text-align: center; margin-top: 20px; color: #888; font-size: 0.8em;">
    <p>This is an automated message, please do not reply to this email.</p>
  </div>
</body>
</html>
`;

const PASSWORD_RESET_SUCCESS_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Password Changed Successfully</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      color: #333;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .header {
      text-align: center;
      padding: 20px;
      border-bottom: 1px solid #eeeeee;
    }
    .header h1 {
      color: #333;
      font-size: 24px;
    }
    .content {
      font-size: 16px;
      line-height: 1.6;
      color: #555;
      padding: 20px;
    }
    .content p {
      margin: 10px 0;
    }
    .footer {
      text-align: center;
      font-size: 12px;
      color: #888;
      padding: 10px;
      border-top: 1px solid #eeeeee;
      margin-top: 20px;
    }
    .button {
      display: inline-block;
      padding: 10px 20px;
      background-color: #4CAF50;
      color: #ffffff;
      text-decoration: none;
      border-radius: 5px;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Password Changed Successfully</h1>
    </div>
    <div class="content">
      <p>Hello {User},</p>
      <p>We wanted to inform you that your password was successfully changed.</p>
      <p>If you did not make this change, please contact our support team immediately to secure your account.</p>
      <a href="{Support_Link}" class="button">Contact Support</a>
      <p>Thank you for keeping your account secure.</p>
      <p>Best regards,<br>The {Your Company} Team</p>
    </div>
    <div class="footer">
      <p>&copy; 2024 {Your Company}. All rights reserved.</p>
    </div>
  </div>
</body>
</html>

`;

const PASSWORD_RESET_REQUEST_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      color: #333;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    .container {
      width: 100%;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .header {
      text-align: center;
      padding: 20px;
    }
    .header h1 {
      color: #333;
    }
    .content {
      font-size: 16px;
      line-height: 1.6;
      color: #555;
    }
    .content p {
      margin: 10px 0;
    }
    .password-box {
      text-align: center;
      padding: 10px;
      font-size: 18px;
      font-weight: bold;
      color: #fff;
      background-color: #4CAF50;
      border-radius: 5px;
      margin: 20px 0;
    }
    .footer {
      text-align: center;
      font-size: 12px;
      color: #888;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Reset Password Request</h1>
    </div>
    <div class="content">
      <p>Dear {User},</p>
      <p>You have requested to reset your password. Here is your temporary password. Please use this to log in, and make sure to update your password afterward.</p>
      <div class="password-box">
        {Your_Temporary_Password}
      </div>
      <p>If you did not request this password reset, please ignore this email or contact support.</p>
      <p>Best regards,<br> {Your Website Team}</p>
    </div>
    <div class="footer">
      <p>&copy; 2024 {Your Website}. All rights reserved.</p>
    </div>
  </div>
</body>
</html>
`;

const WELCOME_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to Our Platform!</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
  <div style="background: linear-gradient(to right, #4CAF50, #45a049); padding: 20px; text-align: center;">
    <h1 style="color: white; margin: 0;">Welcome to Our Platform!</h1>
  </div>
  <div style="background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <p>Hello {userName},</p>
    <p>We're thrilled to welcome you to our platform! Thank you for joining us.</p>
    <p>Your account has been successfully created and verified. Here are a few things you can do now:</p>
    <ul>
      <li>Complete your profile</li>
      <li>Explore our features</li>
      <li>Connect with other users</li>
      <li>Start using our services</li>
    </ul>
    <p>If you have any questions or need assistance, don't hesitate to reach out to our support team.</p>
    <div style="text-align: center; margin: 30px 0;">
      <a href="{loginURL}" style="background-color: #4CAF50; color: white; padding: 12px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">Log In to Your Account</a>
    </div>
    <p>We're excited to have you on board and look forward to seeing you make the most of our platform!</p>
    <p>Best regards,<br>The {appName} Team</p>
  </div>
  <div style="text-align: center; margin-top: 20px; color: #888; font-size: 0.8em;">
    <p>This is an automated message, please do not reply to this email.</p>
  </div>
</body>
</html>
`;

module.exports = {
  VERIFICATION_EMAIL_TEMPLATE,
  PASSWORD_RESET_SUCCESS_TEMPLATE,
  PASSWORD_RESET_REQUEST_TEMPLATE,
  WELCOME_TEMPLATE,
};
