const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const AccessController = require("../../controllers/access.controller");
const User = require("../../models/user.model");

router.get("/verify", async (req, res) => {
  const { token } = req.query;

  try {
    // Xác minh token
    const decoded = jwt.verify(token, "secret_key");
    const email = decoded.email;

    // Tìm user với email
    const user = await User.findOne({
      where: { email, verificationToken: token },
    });

    if (!user) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy người dùng hoặc token không hợp lệ" });
    }

    // Cập nhật trạng thái xác minh
    user.isVerified = true;
    user.verificationToken = null; // Xóa token xác minh
    await user.save();

    res.status(200).json({ message: "Xác minh email thành công!" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi xác minh", error });
  }
});
module.exports = router;
