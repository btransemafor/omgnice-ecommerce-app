const { handleServiceCallback } = require("../utils/responseHelper");
const userService = require("../services/user.services");

// user.controller.js
const getAllUsers = async (req, res) => {
  userService.getAllUsers(
    { includeStatistics: req.query.includeStatistics },
    (err, result) => {
      if (err) {
        console.error("Error in getAllUsers controller:", err);
        return res.status(500).json({ message: "Server error" });
      }
      return res.status(200).json(result);
    }
  );
};

const getUserById = (req, res) => {
  userService.getUserById(req.params.id, (error, result) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ message: error.message });
    }

    if (!result.success) {
      return res.status(404).json(result);
    }

    return res.status(200).json(result);
  });
};
const updateUserByID = (req, res) => {
  const userIdToUpdate = req.params.id;
  const currentUserId = req.user.id;
  const updateData = req.body;

  // Prevent self-block
  const isSelfUpdate = currentUserId === userIdToUpdate;
  const isDeactivating = updateData.is_active === "false";

  if (isSelfUpdate && isDeactivating) {
    return res
      .status(403)
      .json({ message: "Bạn là admin, không thể tự khóa tài khoản của mình." });
  }

  userService.updateUser(
    { id: userIdToUpdate, updateData },
    (error, result) => {
      if (error) {
        return res.status(500).json({ message: error.message });
      }

      if (!result.success) {
        return res.status(404).json({ message: result.message });
      }

      return res.status(200).json(result);
    }
  );
};

const getProfile = (req, res) => {
  const user_id = req.params.id || req.user.id; // Ưu tiên id trên URL nếu có

  console.log("Lấy thông tin user_id:", user_id);

  userService.getProfile(
    { includeStatistics: req.query.includeStatistics },
    user_id,
    (error, result) => {
      if (error) {
        return res.status(500).json({ message: error.message });
      }
      if (!result.success) {
        return res.status(404).json(result);
      }
      return res.status(200).json(result);
    }
  );
};

const updateProfile = (req, res) => {
  const user_id = req.user.id; // Lấy từ token
  const userData = req.body;

  console.log(userData);

  if (!userData || Object.keys(userData).length === 0) {
    return res.status(400).json({ message: "Dữ liệu không hợp lệ" });
  }

  // Nếu có ảnh mới upload, thêm avatar URL vào dữ liệu cập nhật
  if (req.file && req.file.path) {
    userData.avatar = req.file.path;
  }

  userData.id = user_id;

  userService.updateProfile(userData, (err, result) => {
    if (err) {
      return res.status(500).json({ message: err.message });
    }
    return res.status(200).json(result);
  });
};

const checkPassword = (req, res) => {
  const user_id = req.user.id;

  //  dấu ngoặc nhọn ({}) dùng để destructure (phân rã) giá trị từ một đối tượng, hoặc tạo một object literal.

  const { currentPassword } = req.body; // trời ơi phải có ngoặc nhọn.
  console.log(currentPassword);

  userService.checkPassword(
    { user_id, currentPassword },
    handleServiceCallback(res)
  );
};

const addProductFavorite = (req, res) => {
  const user_id = req.user.id; // Lấy từ token user đã đăng nhập
  console.log(user_id);
  const product_id = req.params.product_id; // Lấy product_id từ body gửi lên

  console.log(product_id);

  // Kiểm tra thiếu dữ liệu
  if (!product_id) {
    return res.status(400).json({
      success: false,
      message: "Product ID is required",
    });
  }

  userService.addProductFavorite({ user_id, product_id }, (error, result) => {
    if (error) {
      // Lỗi server (ví dụ crash DB)
      return res.status(500).json({ message: "Internal server error" });
    }
    if (result.success === false) {
      // Xử lý logic lỗi
      return res.status(409).json(result);
    }
    // Thành công
    return res.status(201).json(result);
  });
};

const getUserFavoriteProduct = (req, res) => {
  const user_id = req.user.id;
  console.log(user_id);
  userService.getFavoriteProduct(user_id, (error, result) => {
    if (error) {
      return res.status(500).json({ message: "Server Internal Error" });
    }
    return res.status(200).json(result);
  });
};

const deleteFavoriteProduct = (req, res) => {
  const user_id = req.user.id;
  const product_id = req.params.product_id;
  if (!product_id) {
    return res.status(400).json({ message: "Bad request" });
  }
  userService.deleteFavoriteProduct(
    { user_id, product_id },
    handleServiceCallback(res)
  );
};

// Constants for role IDs
const ROLE_ADMIN = 2;

// UUID validation regex
const UUID_REGEX =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Controller: Get user statistics
const getStatisticUser = async (req, res) => {
  const userId = req.params.id; // Keep as string for UUID
  const user_id = req.user.id;
  if (!userId || !UUID_REGEX.test(userId)) {
    return res.status(400).json({
      success: false,
      message: "Invalid user ID format. Must be a valid UUID.",
    });
  }

  const requester = req.user;

  // Role-based access: Admins (role_id = 2) can view any user’s stats; others can only view their own
  if (requester.role_id !== ROLE_ADMIN && requester.id !== userId) {
    return res.status(403).json({
      success: false,
      message: "You are not authorized to view this data",
    });
  }

  /* 
    // Check if user exists
    const userExists = await db.user.findByPk(userId);
    if (!userExists) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    } */

  const result = await userService.getStatisticUser(userId, (error, result) => {
    if (error) {
      console.error("Error in getStatisticUser controller:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }

    return res.status(200).json(result);
  });
};

const spinWheel = async (req, res) => {
  try {
    const userId = req.user.id;
    console.log(userId);

    const isAllowed = await userService.canSpinToday(userId);

    if (!isAllowed) {
      return res.status(403).json({
        success: false,
        message: "Bạn đã hết lượt quay hôm nay.",
      });
    }

    // Cho phép quay – phần frontend tự xử lý random
    return res.status(200).json({
      success: true,
      message: "Bạn có thể quay vòng quay may mắn.",
    });
  } catch (error) {
    console.error("Spin error:", error);
    return res.status(500).json({
      success: false,
      message: "Lỗi hệ thống khi kiểm tra lượt quay.",
    });
  }
};

const increasePoint = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { amount } = req.body;

    if (!user_id || !amount) {
      return res
        .status(400)
        .json({ success: false, message: "Thiếu user_id hoặc amount" });
    }

    const result = await userService.addPoint(user_id, amount);
    const status = result.success ? 200 : 400;

    return res.status(status).json(result);
  } catch (error) {
    console.error("increasePoint error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Lỗi server", error: error.message });
  }
};

const decreasePoint = async (req, res) => {
  try {
    const { user_id, amount } = req.body;

    if (!user_id || !amount) {
      return res
        .status(400)
        .json({ success: false, message: "Thiếu user_id hoặc amount" });
    }

    const result = await userService.subtractPoint(user_id, amount);
    const status = result.success ? 200 : 400;

    return res.status(status).json(result);
  } catch (error) {
    console.error("decreasePoint error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Lỗi server", error: error.message });
  }
};

const deleteUserController = async (req, res) => {
  const userId = req.params.id;
  const currentUserId = req.user.id; // Assuming verifyToken middleware adds the authenticated user's ID to req.user

  userService.deleteUser(userId, currentUserId, (error, result) => {
    if (error) {
      return res.status(500).json(error);
    }
    return res.status(result.success ? 200 : 400).json(result);
  });
};


module.exports = {
  increasePoint,
  decreasePoint,
  spinWheel,
  getAllUsers,
  getUserById,
  updateUserByID,
  getProfile,
  updateProfile,
  checkPassword,
  addProductFavorite,
  getUserFavoriteProduct,
  deleteFavoriteProduct,
  getStatisticUser,
  deleteUserController,
};
