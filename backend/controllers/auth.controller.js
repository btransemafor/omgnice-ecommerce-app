const userService = require("../services/user.services");
const authService = require("../services/authToken.services");
const bcryptjs = require("bcryptjs");

const jwt = require("jsonwebtoken");

const { db } = require("../models/index");

const sendOtpEmail = require("../services/email.services");

const login = async (req, res, next) => {
  // Get Data from Post
  const { email, password } = req.body;
  console.log(email); 

  // Call userService
  userService.login({ email, password }, (error, data) => {
    if (error) {
      console.error(error);
      return next(error); // Forward error to the global error handler
    }

    if (!data.success) {
      // Handle failed login with appropriate status
      return res.status(401).json({
        success: false,
        message: data.message,
        requireVerification: data.requireVerification || false,
        userId: data.userId,
        expiresAt: data.expiresAt,
      });
    }

    return res.status(200).json({
      success: true,
      message: "Đăng nhập thành công",
      data: data.data,
    });
  });
};

const register = async (req, res, next) => {
  try {
    const { name, email, phone, password, role_id } = req.body;
    console.log("[Register] Data:", { name, email, phone, role_id });

    // Call the service function with the request data
    userService.register(
      {
        name,
        email,
        phone,
        password,
        role_id, // Không cần bắt buộc
      },
      (error, result) => {
        if (error) {
          console.error(error);
          return next(error);
        }

        if (!result.success) {
          return res.status(400).json(result);
        }

        return res.status(201).json(result);
      }
    );
  } catch (error) {
    if (error.message) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
    next(error); // Pass other errors to the global error handler
  }
};

// -------------- Cap lai AccessToken ----------------
const refreshToken = async (req, res, next) => {
  const refreshToken = req.body.token;
  if (!refreshToken) {
    return res.status(401).json({ message: "Refresh token not found" });
  }

  authService.refreshToken(refreshToken, (error, result) => {
    if (error) {
      console.error(error);
      return next(error); // Forward error to the global error handler
    }

    if (!result.success) {
      return res.status(400).json(result);
    }

    next();
    //return res.status(200).json(result);
  });
};

// -------- Xac thuc luc dang Ky ----------

exports.verifyEmail = async (req, res) => {
  userService.verifyOtpWithPurpose(
    {
      userId: req.body.userId,
      otpCode: req.body.otp,
      purpose: "verify_email",
    },
    userService.activateUserById,
    (err, result) => {
      if (err)
        return res.status(500).json({ success: false, message: err.message });
      res.json(result);
    }
  );
};

// ---------------Xac thuc de reset password ---------------------
const verifyResetPW = async (req, res) => {
  userService.verifyOtpWithPurpose(
    {
      userId: req.body.userId,
      otpCode: req.body.otp,
      purpose: "reset_password",
    },
    userService.activateUserById,
    (err, result) => {
      if (err)
        return res.status(500).json({ success: false, message: err.message });
      res.json(result);
    }
  );
};

// ----------------- Cap nhat PW moi ------------------

const resendVerificationOtp = async (req, res, next) => {
  try {
    const { email } = req.body;
    console.log(email); 

    userService.resendVerificationOtp({ email }, (error, result) => {
      if (error) {
        console.error(error);
        return next(error);
      }

      if (!result.success) {
        return res.status(400).json(result);
      }

      return res.status(200).json(result);
    });
  } catch (error) {
    next(error);
  }
};

// ---------------- Ham gui OTP xac thuc khi quen mat khau ==========
const sendResetOtp = async (req, res, next) => {
  try {
    const { email } = req.body;
    console.log(email);

    userService.sendResetOtp(email, (error, result) => {
      if (error) {
        console.log(error);
        return next(error);
      }
      if (!result.success) {
        return res.status(400).json(result);
      }

      return res.status(200).json(result);
    });
  } catch (error) {
    return next(error);
  }
};

// -------------------------- Xac Thuc =======================

const verifyOtp = async (req, res, next) => {
  try {
    const { email, otpCode } = req.body;

    userService.verifyOtp({ email, otpCode }, (error, result) => {
      if (error) {
        console.error(error);
        return next(error);
      }

      if (!result.success) {
        return res.status(400).json(result);
      }

      return res.status(200).json(result);
    });
  } catch (error) {
    next(error);
  }
};

const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;

    // Assuming a forgotPassword service exists in userService
    userService.forgotPassword({ email }, (error, result) => {
      if (error) {
        console.error(error);
        return next(error);
      }

      if (!result.success) {
        return res.status(400).json(result);
      }

      return res.status(200).json(result);
    });
  } catch (error) {
    next(error);
  }
};

/*
const resetPassword = async (req, res, next) => {
    try {
      const { email, newPassword } = req.body;
    
      if (!newPassword) {
        return res.status(400).json({ message: 'Thiếu mật khẩu mới' });
      }
      console.log(newPassword); 
      userService.resetPassword( { email, newPassword } , (error, result) => {

        if (error) {
            console.error(error);
            return next(error);
        }
        
        if (!result.success) {
            return res.status(400).json(result);
        }
        
        return res.status(200).json(result);
      })

    } catch (err) {
      console.error('[RESET PASSWORD ERROR]', err.message);
      res.status(500).json({ message: 'Lỗi server khi đổi mật khẩu' });
    }
  };

//// ---------------- Reset Password ------------------- // 

const resetPassword = (req, res) => {
    const new_password = req.body; 
    if (!new_password) {
      return res.status(400).json({message: 'Bad Request'}); 
    }
    const user_id = req.user.id ; 
    param.new_password = new_password; 
    param.user_id = user_id; 
  
    userService.resetPassword(param, (error, result) => {
      if (error ) {
        return res.status(500).json(error.message); 
      }
      if (!result.success) {
        return res.status(404).json(result); 
      }
      return res.status(200).json(result); 
    })
  }
  
*/

// Middleware reset password - dùng cho cả forgot-password hoặc đã login
const resetPassword = async (req, res) => {
  const { email, newPassword } = req.body;
  const userId = req.user?.id;
  console.log(`TOKEN:  ${userId} `); 

  if (!newPassword || newPassword.length < 6) {
    return res
      .status(400)
      .json({ message: "Mật khẩu phải có ít nhất 6 ký tự." });
  }

  // Phải có userId hoặc email (1 trong 2)
  if (!userId && !email) {
    return res
      .status(400)
      .json({ message: "Thiếu thông tin xác định người dùng." });
  }

  // Gọi service
  userService.resetPassword({ newPassword, email, userId }, (error, result) => {
    if (error) {
      return res.status(500).json({ message: "Lỗi server khi đổi mật khẩu" });
    }

    if (!result.success) {
      return res.status(400).json(result);
    }

    return res.status(200).json(result);
  });
};

// ---------------- Logout -----------------

const logout = async (req, res) => {
  const refreshToken = req.body.refreshToken;
  console.log("Refresh Token:", refreshToken);

  if (!refreshToken) {
    return res.status(401).json({ message: "Refresh token not found" });
  }

  userService.logout(refreshToken, (error, result) => {
    if (error) {
      console.error(error);
      return next(error); // Forward error to the global error handler
    }

    if (!result.success) {
      return res.status(400).json(result);
    }

    return res.status(200).json(result);
  });
};

module.exports = {
  login,
  register,
  resendVerificationOtp,
  forgotPassword,
  resetPassword,
  sendResetOtp,
  verifyOtp,
  refreshToken,
  logout,
};
