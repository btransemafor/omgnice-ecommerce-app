const express = require('express');
const { login, register, verifyOtp ,resetPassword,sendResetOtp,resendVerificationOtp, refreshToken, logout } = require('../controllers/auth.controller');
const validateemail = require("../middleware/validate_email_middleware"); 
const validatephone = require("../middleware/validate_phone_middleware"); 
const validateRegisterInput = require('../middleware/validateRegisterInput');
const { authenticateToken } = require('../middleware/authJwt'); 
const {verifyAndLogin} = require('../controllers/googleAuth.controller.js'); 
const loginLimiter = require('../middleware/rateLimiter.middleware'); 
const router = express.Router();

// Định nghĩa các API cho authentication
// router.post('/register', register); // Tham số thứ 2 là controller / có thể là một mảng controlle
router.post('/login', validateemail, loginLimiter.loginLimiter, login);
router.post('/register', validateRegisterInput, register);

//router.post("/verify-account", verifyAccount);
//router.post("/resend-verification", resendVerificationOtp);

// reset password 

router.post('/verify-otp', verifyOtp); 
router.post('/reset-password', resetPassword);
router.post('/change-password', resetPassword); 
router.post('/send-reset-otp', sendResetOtp ); 
router.post('/resend-otp-verify', resendVerificationOtp); 

router.post('/refresh-token', refreshToken);
router.delete('/logout', logout); 
router.post('/google/verify', verifyAndLogin); 
module.exports = router;
