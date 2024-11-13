//access controller
const { SuccessResponse } = require("../core/success.response");
const AccessService = require("../services/access.service");

class AccessController {
  // signUp = async (req, res, next) => {
  //     new SuccessResponse({
  //         message: "Sign up successfully",
  //         metadata: await AccessService.signUp(req.body),
  //     }).send(res);
  // }

  // signIn = async (req, res, next) => {
  //     new SuccessResponse({
  //         message: "Sign in successfully",
  //         metadata: await AccessService.signIn(req.body),
  //     }).send(res);
  // }

  // logout = async (req, res, next) => {
  //     new SuccessResponse({
  //         message: "Logout successfully",
  //         metadata: await AccessService.logout(req.refreshToken),
  //     }).send(res);
  // }

  register = async (req, res, next) => {
    return new SuccessResponse({
      message: "Register successfully!!",
      metadata: await AccessService.register(req.body),
    }).send(res);
  };

  verify_account = async (req, res, next) => {
    const { email, otpCode } = req.body;
    return new SuccessResponse({
      message: "Account verified ",
      metadata: await AccessService.verify_account({ email, otpCode }),
    }).send(res);
  };

  resend_code = async (req, res, next) => {
    const { email } = req.body;
    return new SuccessResponse({
      message: "Resend code",
      metadata: await AccessService.resend_code({ email }),
    }).send(res);
  };

  login = async (req, res, next) => {
    return new SuccessResponse({
      message: "Login successfully!!",
      metadata: await AccessService.login(req.body),
    }).send(res);
  };

  logout = async (req, res, next) => {
    const { userId } = req.user;
    const accessToken = req.accessToken;
    return new SuccessResponse({
      message: "Successfully logged out.",
      metadata: await AccessService.logout({ userId, accessToken }),
    }).send(res);
  };

  logout_all_device = async (req, res, next) => {
    const { userId } = req.user;
    return new SuccessResponse({
      message: "Successfully logged out all device.",
      metadata: await AccessService.logout_all_device({ userId }),
    }).send(res);
  };

  reset_password = async (req, res, next) => {
    const { email } = req.body;
    return new SuccessResponse({
      message: "A new password send to your email. Check your email.",
      metadata: await AccessService.reset_password({ email }),
    }).send(res);
  };

  change_password = async (req, res, next) => {
    const { userId } = req.user;
    const accessToken = req.accessToken;
    const { oldPassword, newPassword } = req.body;
    return new SuccessResponse({
      message: "Change password successfully.",
      metadata: await AccessService.change_password({
        userId,
        oldPassword,
        newPassword,
        accessToken,
      }),
    }).send(res);
  };
}
module.exports = new AccessController();
