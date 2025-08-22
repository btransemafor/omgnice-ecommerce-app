const express = require("express");
const { isAdmin } = require("../middleware/authJwt");
const userController = require("../controllers/user.controller");
const router = express.Router();
const {setAvatarFolder} = require('../middleware/setFolder');
const {upload} = require('../middleware/upload.middleware'); 
router.get("/profile", userController.getProfile); // /// ????? Chú ý thứ tự khai báo route nha omggggggg
router.get("/profile/:id", isAdmin, userController.getProfile)
router.put(
    "/profile",
    setAvatarFolder,              // Gắn thư mục lưu
    upload.single("avatar"),      // Upload ảnh
    userController.updateProfile  // Cập nhật thông tin user
  );
router.delete('/', userController.deleteUserController); 
router.delete('/:id', isAdmin, userController.deleteUserController)
router.get("/favorites", userController.getUserFavoriteProduct);
router.delete("/favorites/:product_id", userController.deleteFavoriteProduct);
router.post("/checkpw", userController.checkPassword);
router.get("/", isAdmin, userController.getAllUsers);
router.get("/:id", isAdmin, userController.getUserById);
router.put("/:id", isAdmin, userController.updateUserByID);
router.post("/favorites/:product_id", userController.addProductFavorite);
router.get('/statistics/:id', userController.getStatisticUser);
// Middleware xác thực req.user.id
router.post('/spin', userController.spinWheel);
//  Cộng điểm
router.post('/point/add', userController.increasePoint);
//  Trừ điểm
router.post('/point/subtract', userController.decreasePoint);
module.exports = router;
