const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { Op, where } = require("sequelize");
const { db } = require("../models/index");
const auth = require("../middleware/authJwt");
const otpService = require("./otp.services");
const notificationService = require("./notifications.services");
const authTokenService = require("./authToken.services");
const {
  sendOtpResetPW,
  sendOtpVerifyAccount,
  sendEmailChangePassword,
} = require("../services/email.services");

///  ------------------------- Chuc Nang Dang Ky =-=====-----------------

async function register(userData, callback) {
  try {
    console.log("Starting user registration for:", userData.email);
    console.log("Starting user registration for:", userData.role_id);

    // Check existing user
    const existingUser = await db.user.findOne({
      where: { email: userData.email },
    });

    if (existingUser) {
      console.log("Email already in use:", userData.email);
      return callback(null, {
        success: false,
        message: "Email đã được sử dụng.",
      });
    }

    console.log("Hashing password...");
    // Hash password
    const salt = bcrypt.genSaltSync(10);
    const hashedPassword = bcrypt.hashSync(userData.password, salt);

    console.log("Creating new user...");
    // Create new user
    const newUser = await db.user.create({
      name: userData.name,
      email: userData.email,
      phone: userData.phone,
      password: hashedPassword,
      point: 50, // Mặc định 50 khi vừa tạo tài khoản
      role_id: 1 || userData.role_id, // nếu không có thì dùng mặc định (1 = user),
      active: false,
    });

    // ----------- Tạo Cart_id khi đăng kí một tài khoản ------------------ //

    const userCart = await db.cart.create({
      user_id: newUser.id,
    });

    console.log("User created, ID:", newUser.id);

    try {
      console.log("Creating OTP...");
      // Create OTP
      const otpInfo = await otpService.createOtp(
        newUser.id,
        "verify_email",
        30
      );
      console.log("OTP created:", otpInfo.otpCode);

      try {
        console.log("Sending email...");
        // Send OTP email
        await sendOtpVerifyAccount(userData.email, otpInfo);
        console.log("Email sent successfully");
      } catch (emailError) {
        console.error("Error sending email:", emailError);
        // Continue despite email error
      }
    } catch (otpError) {
      console.error("Error creating OTP:", otpError);
      // Continue despite OTP error
    }

    // --------------- Trigger Thông báo khi tạo tài khoản mới ----------------------- //
    notificationService.createNotification(
      {
        user_id: newUser.id,
        title: "Welcome to OMGNice!",
        message: "Thanks for signing up. Happy to have you! ❤️",
        type: "system",
      },
      () => {} // Không cần callback trả về, hoặc có thể log)
    );
    // Return response
    const responseData = newUser.toJSON();
    responseData.cart_id = userCart.id;
    delete responseData.password;

    return callback(null, {
      success: true,
      message:
        "Đăng ký thành công. Vui lòng xác thực tài khoản qua mã OTP đã được gửi đến email của bạn.",
      data: responseData,
    });
  } catch (error) {
    console.error("Registration error:", error);
    return callback(error);
  }
}

// ------------------------ LOGIN ----------------------- //

/**
 * Đăng nhập
 * @param {Object} param - Thông tin đăng nhập
 * @param {Function} callback - Callback function
 */

async function login(param, callback) {
  try {
    const email = param.email;
    const password = param.password;

    // Tìm user theo email
    const user = await db.user.findOne({ where: { email: email } });

    if (!user) {
      return callback(null, {
        success: false,
        message: "Email không tồn tại!",
      });
    }

    // Kiểm tra tài khoản đã kích hoạt chưa
    if (!user.active) {
      return callback(null, {
        success: false,
        message:
          "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email và nhập mã xác thực.",
        requireVerification: true,
        userId: user.id,
        //expiresAt: otpInfo.expiresAt
      });
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = bcrypt.compareSync(password, user.password);

    if (!isPasswordValid) {
      return callback(null, {
        success: false,
        message: "Mật khẩu không đúng or chưa xác thực",
      });
    }

    // Tạo JWT token
    const token = auth.generateAccessToken({
      id: user.id,
      email: user.email,
      role_id: user.role_id,
    });

    // Tạo refresh token
    const refreshToken = await authTokenService.generateRefreshToken({
      id: user.id,
      email: user.email,
      role_id: user.role_id,
    }); // ví dụ: trả về JWT 7 ngày và lưu vào DB

    // Convert user to JSON và loại bỏ thông tin nhạy cảm
    const userData = user.toJSON();
    userData.accessToken = token;
    userData.refreshToken = refreshToken;
    delete userData.password;

    return callback(null, {
      success: true,
      message: "Đăng nhập thành công",
      data: userData,
    });
  } catch (error) {
    return callback(error);
  }
}

// --------------------- Logout ------------------- //
async function logout(param, callback) {
  try {
    const refreshToken = param;
    if (!refreshToken) {
      return callback(null, {
        success: false,
        message: "Refresh token không tồn tại",
      });
    }

    // Xoá refresh token trong DB
    await db.authToken.destroy({
      where: {
        token: refreshToken,
        is_active: true,
      },
    });

    return callback(null, {
      success: true,
      message: "Đăng xuất thành công",
    });
  } catch (error) {
    return callback(error);
  }
}

/**
 * Gửi lại OTP xác thực tài khoản
 * @param {Object} param - Thông tin người dùng
 * @param {Function} callback - Callback function
 */
async function resendVerificationOtp(param, callback) {
  try {
    const email = param.email; // Extract email from param
    console.log("Email being searched:", email);

    const user = await db.user.findOne({
      where: { email: email },
    });


    if (!user) {
      return callback(null, {
        success: false,
        message: "Email không tồn tại",
      });
    }

    // Kiểm tra xem tài khoản đã kích hoạt chưa
    if (user.active) {
      return callback(null, {
        success: false,
        message: "Tài khoản đã được kích hoạt",
      });
    }

    // Tạo OTP mới
/*     const otpInfo = await otpService.createOtp(user.id, "verify_email", 1);
    console.log("OTP created:", otpInfo.otpCode);
    console.log(otpInfo);
    sendOtpVerifyAccount(email, otpInfo); */

     try {
      console.log("Creating OTP...");
      // Create OTP
      const otpInfo = await otpService.createOtp(
      user.id,
        "verify_email",
        30
      );
      console.log("OTP created:", otpInfo.otpCode);

      try {
        console.log("Sending email...");
        // Send OTP email
        await sendOtpVerifyAccount(userData.email, otpInfo);
        console.log("Email sent successfully");
      } catch (emailError) {
        console.error("Error sending email:", emailError);
        // Continue despite email error
      }
    } catch (otpError) {
      console.error("Error creating OTP:", otpError);
      // Continue despite OTP error
    }

    return callback(null, {
      success: true,
      message: "Đã gửi lại mã xác thực đến email của bạn",
      userId: user.id,
      expiresAt: otpInfo.expiresAt,
    });
  } catch (error) {
    return callback(error);
  }
}

async function sendResetOtp(param, callback) {
  // Tìm user theo email
  try {
    const email = param; // Loi cho nay
    // Kiểm tra đầu vào
    const user = await db.user.findOne({ where: { email } });

    if (!user) {
      return callback(null, {
        success: false,
        message: "Email không tồn tại!",
      });
    }
    // Ton tai
    // Tao OTP
    const otpInfo = await otpService.createOtp(user.id, "reset_password", 10);
    // Send email
    await sendOtpResetPW(email, otpInfo);
    return callback(null, {
      success: true,
      message: "Đã gửi mã để đặt lại mật khẩu",
    });
  } catch (e) {
    return callback(e);
  }
}

async function resetPassword(params, callback) {
  // Sửa tên biến để phù hợp với dữ liệu đầu vào
  const { newPassword, userId, email } = params;
  console.log("Param:", params);
  let isChangePW = false;
  if (!email) {
    isChangePW = true;
  }

  try {
    const whereCondition = {};

    if (userId) {
      whereCondition.id = userId;
    }

    if (email) {
      whereCondition.email = email;
    }

    if (Object.keys(whereCondition).length === 0) {
      return callback(null, {
        success: false,
        message: "Vui lòng cung cấp userId hoặc email.",
      });
    }

    const user = await db.user.findOne({
      where: whereCondition,
    });

    if (!user) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy người dùng.",
      });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await user.update({ password: hashedPassword });

    if (isChangePW) {
      // Send email neu do la changePassword.
      console.log("Sending email...");
      // Send OTP email
      await sendEmailChangePassword(user.email);
      console.log("Email sent successfully");
    }

    // Gửi thông báo hệ thống khi đổi mật khẩu thành công
    notificationService.createNotification(
      {
        user_id: user.id,
        title: "Password Changed Successfully",
        message:
          "You have successfully changed your password. If this wasn't you, please contact support immediately.",
        type: "system",
      },
      () => {}
    );

    // Cleanup OTP đã dùng
    await db.otp.destroy({
      where: {
        user_id: user.id,
        used: true,
        // expired_at: { [Op.lt]: new Date() } // tùy yêu cầu
      },
    });

    return callback(null, {
      success: true,
      message: "Đổi mật khẩu thành công!",
    });
  } catch (error) {
    console.error("[ERROR] resetPassword:", error);
    return callback(error);
  }
}

// Xac thuc otp
const verifyOtp = async (param, callback) => {
  const { email, otpCode } = param;

  try {
    if (!email || !otpCode) {
      return callback(null, {
        success: false,
        message: "Thiếu email hoặc mã OTP",
      });
    }

    // 🔍 Tìm user theo email
    const user = await db.user.findOne({ where: { email } });
    if (!user) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy người dùng",
      });
    }

    const userId = user.id;

    // 🔍 Lấy tất cả OTP còn hạn và chưa dùng
    const otps = await db.otp.findAll({
      where: {
        user_id: userId,
        used: false,
        expires_at: { [Op.gt]: new Date() },
      },
      order: [["createdAt", "DESC"]],
    });

    // So sánh từng OTP đã hash
    let matchedOtp = null;
    for (let otp of otps) {
      if (!otp.otp_code) continue;

      const match = await bcrypt.compare(otpCode, otp.otp_code); // dùng async
      if (match) {
        matchedOtp = otp;
        break;
      }
    }

    //  Nếu không tìm thấy OTP khớp
    if (!matchedOtp) {
      return callback(null, {
        success: false,
        message: "Mã OTP không hợp lệ hoặc đã hết hạn",
      });
    }

    //  Đánh dấu OTP đã dùng
    matchedOtp.used = true;
    await matchedOtp.save();

    //  Xử lý theo loại OTP
    console.log("Matched OTP type:", matchedOtp.purpose);

    if (matchedOtp.purpose === "verify_email") {
      user.active = true;
      await user.save();
      return callback(null, {
        success: true,
        message: "Xác thực email thành công!",
      });
    }

    if (matchedOtp.purpose === "reset_password") {
      return callback(null, {
        success: true,
        message: "OTP hợp lệ. Bạn có thể đặt lại mật khẩu.",
        canResetPassword: true,
        userId: user.id,
      });
    }

    //  Nếu không nằm trong các loại hỗ trợ
    return callback(null, {
      success: false,
      message: "Loại OTP không được hỗ trợ",
    });
  } catch (err) {
    return callback(err);
  }
};

// GET USERS

//const {db} = require('../models/index');

const User = db.user;
// Controller cho /users
// user.services.js
const getAllUsers = async (options = {}, callback) => {
  try {
    console.log("DEBUG đang tiến hành get users");

    const users = await db.user.findAll({
      attributes: { exclude: ["password"] },
    });

    // Nếu yêu cầu thống kê, gọi getStatisticUser từng người
    if (options.includeStatistics === "true") {
      for (let user of users) {
        const stats = await new Promise((resolve) => {
          getStatisticUser(user.id, (err, result) => {
            if (err || !result.success) return resolve(null);
            resolve(result.data);
          });
        });
        user.dataValues.statistics = stats;
      }
    }

    return callback(null, {
      success: true,
      data: users,
    });
  } catch (error) {
    console.error("Error in getAllUsers:", error);
    return callback(error);
  }
};

const getUserById = async (id, callback) => {
  try {
    const user = await User.findByPk(id, {
      attributes: { exclude: ["password"] },
    });

    if (!user) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy người dùng trong hệ thống.",
      });
    }

    return callback(null, {
      success: true,
      message: "Lấy thông tin người dùng thành công.",
      data: user, // ✅ thêm data để controller lấy được
    });
  } catch (error) {
    return callback(error);
  }
};

/// ---------------- Update User --------------------- //

const updateUser = async (param, callback) => {
  try {
    const id = param.id;
    const updateData = param.updateData;

    // Cần await khi gọi update
    const [affectedRows] = await User.update(updateData, {
      where: { id },
    });

    if (affectedRows === 0) {
      return callback(null, {
        success: false,
        message: "User không tồn tại hoặc không có gì thay đổi",
      });
    }

    // Lấy user mới sau khi cập nhật
    const updatedUser = await User.findByPk(id, {
      attributes: { exclude: ["password"] },
    });

    return callback(null, {
      success: true,
      message: "Cập nhật thông tin user thành công",
      data: updatedUser,
    });
  } catch (error) {
    return callback(error);
  }
};

// ------------------- Get Profile User ------------------------ //
const getProfile = async (options = {}, userId, callback) => {
  try {
    console.log(userId);
    const user = await db.user.findOne({
      where: { id: userId },
      attributes: [
        "id",
        "name",
        "email",
        "phone",
        "avatar",
        "point",
        "role_id",
        "is_active",
        "createdAt",
      ],
    });

    if (!user) {
      return callback(null, {
        success: false,
        message: "User not found!",
      });
    }

    // Nếu yêu cầu thống kê, gọi getStatisticUser từng người
    if (options.includeStatistics === "true") {
      const stats = await new Promise((resolve) => {
        getStatisticUser(user.id, (err, result) => {
          if (err || !result.success) return resolve(null);
          resolve(result.data);
        });
      });
      user.dataValues.statistics = stats;
    }

    return callback(null, {
      success: true,
      message: `Lấy thông tin người dùng #${user.id} thành công`,
      data: user,
    });
  } catch (error) {
    return callback(error);
  }
};

const updateProfile = async (dataUser, callback) => {
  const { name, email, phone, avatar, id, ward, district, province, details } =
    dataUser;

  try {
    const updateData = { name, email, phone, avatar };

    const [affected_user] = await db.user.update(updateData, {
      where: { id },
    });

    // Tìm userAddress theo user_id
    const userAddress = await db.userAddress.findOne({
      where: { user_id: id },
    });

    if (!userAddress) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy địa chỉ người dùng",
      });
    }

    const address_id = userAddress.address_id;

    const [affected_address] = await db.address.update(
      { ward, district, province, details },
      { where: { address_id } }
    );

    if (affected_user === 0 && affected_address === 0) {
      return callback(null, {
        success: false,
        message: "Không có thay đổi nào được thực hiện",
      });
    }

    return callback(null, {
      success: true,
      message: "Cập nhật hồ sơ thành công",
    });
  } catch (error) {
    return callback(error);
  }
};

/*


const variantProducts = await db.variantProduct.findAll({
        where: { product_id: productId },
        include: [
          {
            model: db.product,
            attributes: ['id', 'name_product', 'imageUrl'],
          },
          {
            model: db.variant,
            attributes: ['id', 'variant_name'],
          }
        ],
      });

      */

// Dùng để check password hiện tại khi user muốn đổi mật khẩu
const checkPassword = async (params, callback) => {
  try {
    const { user_id, currentPassword } = params;

    const user = await db.user.findOne({
      where: { id: user_id },
    });

    if (!user) {
      return callback(null, {
        success: false,
        message: "User not found",
      });
    }
    // Kiem tra xem pw trong db có rỗng không, nếu không là do user login bằng google mà chưa đk thực sự ?
    // TH bỏ qua việc kiểm tra password hiện tại có trùng không ?
    // Trường hợp user đăng nhập bằng Google (chưa có password)
    if (user.password == null) {
      return callback(null, {
        success: true,
        message: "No password set - Skipping check",
      });
    }

    const isPasswordValid = bcrypt.compareSync(currentPassword, user.password);

    if (!isPasswordValid) {
      return callback(null, {
        success: false,
        message: "Invalid password",
      });
    }

    return callback(null, {
      success: true,
      message: "Password is valid",
    });
  } catch (error) {
    console.error("Error in checkPassword:", error);
    return callback(error);
  }
};

const addProductFavorite = async (params, callback) => {
  try {
    const product_id = params.product_id;
    const user_id = params.user_id;

    console.log(product_id);

    if (!product_id) {
      return callback(null, {
        success: false,
        message: "Product not found",
      });
    }

    if (!user_id) {
      return callback(null, {
        success: false,
        message: "User not found",
      });
    }

    // Check xem sản phẩm đã được thêm vào yêu thích chưa
    const existingFavorite = await db.userFavorite.findOne({
      where: {
        user_id: user_id,
        product_id: product_id,
      },
    });

    if (existingFavorite) {
      return callback(null, {
        success: false,
        message: "Product already in favorites",
      });
    }

    const productFavorite = await db.userFavorite.create({
      user_id: user_id,
      product_id: product_id,
    });

    return callback(null, {
      success: true,
      message: "Product added to favorites successfully",
      data: productFavorite,
    });
  } catch (error) {
    return callback(error);
  }
};

const getFavoriteProduct = async (user_id, callback) => {
  try {
    console.log("DEBUG Đang gọi tới service nè .... ");
    //const user = await db.user({where: {id: user_id}});
    const user = await db.user.findByPk(user_id);
    console.log(user);
    if (!user) {
      return callback(null, {
        success: false,
        message: "Không tồn tại user trong hệ thống",
      });
    }

    // Get danh sách
    const userFavoriteProducts = await db.user.findOne({
      where: { id: user_id }, // id của user muốn lấy
      attributes: ["id", "name", "email"],
      include: [
        {
          model: db.product,
          as: "favorite_products", // dùng alias mình đặt ở belongsToMany
          through: { attributes: [] }, // không lấy dữ liệu từ bảng trung gian userFavorite
        },
      ],
    });
    // Join

    return callback(null, {
      message: "Get Product Favorite User Successfully",
      data: userFavoriteProducts,
    });
  } catch (error) {
    return callback(error);
  }
};

/// ------------- DELETE PRODUCT FAVORITE -------------------- ///
const deleteFavoriteProduct = async (params, callback) => {
  try {
    const { product_id, user_id } = params;

    const userFavoriteProduct = await db.userFavorite.findOne({
      where: {
        product_id: product_id,
        user_id: user_id,
      },
    });

    if (!userFavoriteProduct) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy sản phẩm trong mục yêu thích của user",
      });
    }

    // Xóa sản phẩm khỏi yêu thích
    await userFavoriteProduct.destroy();

    return callback(null, {
      success: true,
      message: "Removed Product Favorite Successfully",
    });
  } catch (error) {
    return callback(error);
  }
};

// ---------- Một số chỉ số thống kê cho người dùng --------------------//

// Tổng cộng Số đơn hàng
const getStatisticUser = async (user_id, callback) => {
  try {
    const totalQuantityOrder = await db.order.count({ where: { user_id } });

    const totalSpending = await db.order.sum("orderTotal", {
      where: { user_id },
    });

    const totalCoupon = await db.userPromotion.count({ where: { user_id } });

    const completedOrders = await db.order.count({
      where: { user_id, orderStatus: "completed" },
    });

    const cancelledOrders = await db.order.count({
      where: { user_id, orderStatus: "cancel" },
    });

    const lastOrder = await db.order.findOne({
      where: { user_id },
      order: [["orderDate", "DESC"]],
    });

    // 🔍 Tìm sản phẩm khách đã mua nhiều nhất
    const topProduct = await db.order_line.findOne({
      attributes: [
        "product_id",
        [db.sequelize.fn("SUM", db.sequelize.col("quantity")), "totalQuantity"],
      ],
      include: [
        {
          model: db.product,
          as: "product",
          attributes: ["name_product"],
        },
        {
          model: db.order,
          as: "order",
          attributes: [],
          where: { user_id }, // ✅ CHUYỂN filter user_id vào đây
        },
      ],
      group: ["order_line.product_id", "product.id"],
      order: [[db.sequelize.literal('SUM("quantity")'), "DESC"]],
    });

    const mostPurchasedProduct = topProduct
      ? {
          name: topProduct.product?.name_product || "Unknown",
          quantity: topProduct.dataValues.totalQuantity,
        }
      : null;

    const averageSpending =
      totalQuantityOrder > 0 ? totalSpending / totalQuantityOrder : 0;

    const cancelRate =
      totalQuantityOrder > 0
        ? Number((cancelledOrders / totalQuantityOrder).toFixed(2))
        : 0;

    const result = {
      totalQuantityOrder,
      totalSpending,
      totalCoupon,
      completedOrders,
      cancelledOrders,
      averageSpending,
      cancelRate,
      lastOrderDate: lastOrder?.orderDate || null,
      mostPurchasedProduct,
    };

    return callback(null, { success: true, data: result });
  } catch (error) {
    console.error("Error in getStatisticUser:", error);
    return callback({ success: false, message: "Server error" });
  }
};

const moment = require("moment");
const {
  messagesValidation,
} = require("@pinecone-database/pinecone/dist/assistant/data/chat");

async function canSpinToday(userId) {
  const user = await db.user.findByPk(userId);
  const today = moment().format("YYYY-MM-DD");

  if (user.last_spin_date === today) {
    if (user.spins_today >= 1) {
      return false; // Hết lượt
    } else {
      user.spins_today += 1;
    }
  } else {
    user.last_spin_date = today;
    user.spins_today = 1;
  }

  await user.save();
  return true;
}

async function addPoint(userId, amount) {
  try {
    const user = await db.user.findByPk(userId);
    if (!user) throw new Error("User not found");

    user.point = (user.point || 0) + amount;
    await user.save();


    // Gửi thông báo hệ thống khi tạo đơn hàng thành công
notificationService.createNotification(
  {
    user_id: user.id,
    title: "Congratulations!",
    message: `Congratulations! You have been awarded 50 points. Use them to unlock exciting rewards!`,
    type: "order",
  },
  (err) => {
    if (err) {
      console.error("Error sending order notification:", err);
    }
  }
);


    

    return {
      success: true,
      message: `Đã cộng ${amount} điểm cho người dùng #${userId}`,
      currentPoint: user.point,
    };
  } catch (error) {
    console.error("Error in addPoint:", error);
    return {
      success: false,
      message: "Lỗi khi cộng điểm",
      error: error.message,
    };
  }
}

async function subtractPoint(userId, amount) {
  try {
    const user = await db.user.findByPk(userId);
    if (!user) throw new Error("User not found");

    if ((user.point || 0) < amount) {
      return {
        success: false,
        message: `Người dùng không đủ điểm để trừ. Hiện tại: ${
          user.point || 0
        }`,
      };
    }

    user.point -= amount;
    await user.save();

    return {
      success: true,
      message: `Đã trừ ${amount} điểm của người dùng #${userId}`,
      currentPoint: user.point,
    };
  } catch (error) {
    console.error("Error in subtractPoint:", error);
    return {
      success: false,
      message: "Lỗi khi trừ điểm",
      error: error.message,
    };
  }
}

const deleteUser = async (user_id, current_user_id, callback) => {
  try {
    let user;

    if (user_id) {
      // Nếu có user_id truyền vào (admin xoá user khác)
      user = await db.user.findByPk(user_id);
    } else {
      // Nếu không có user_id (user tự xoá)
      user = await db.user.findByPk(current_user_id);
    }

    if (!user) {
      return callback(null, {
        success: false,
        message: "User does not exist",
      });
    }

    // Xoá user
    await user.destroy();

    return callback(null, {
      success: true,
      message: "Deleted user account successfully!",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Failed to delete user: " + error.message,
    });
  }
};

module.exports = {
  addPoint,
  subtractPoint,
  register,
  resendVerificationOtp,
  login,
  sendResetOtp,
  verifyOtp,
  resetPassword,
  getAllUsers,
  getUserById,
  updateUser,
  getProfile,
  updateProfile,
  logout,
  checkPassword,
  addProductFavorite,
  getFavoriteProduct,
  deleteFavoriteProduct,
  getStatisticUser,
  canSpinToday,
  deleteUser,
};
