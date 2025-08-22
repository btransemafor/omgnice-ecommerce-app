const express = require('express');
const multer = require('multer');
const ProductController = require('../controllers/product.controller'); // Đừng quên import ProductController

const authRoutes = require('./auth.routes');
const userRoutes = require('./user.routes');
const categoryRoutes = require('./category.routes');
const productRoutes = require('./product.routes');  
const variantProductRoutes = require('./variant_product.routes'); 
const cartRoutes = require('./cart.routes'); 
const promotionRoutes = require('./promotion.routes'); 
const orderRoutes = require('./order.routes'); 
const addressRoutes = require('./address.routes'); 
const bannerRoutes = require('./banner.routes');
const shippingRoutes = require('./shipping.routes'); 
const adminRoutes = require('./admin/index.routes')
const paymentRoutes = require('./payment.routes'); 
const contactRoutes =require('./contact.routes'); 
const chatbotRoutes = require('./chatbot.routes')
const reviewRouters = require('./review.routes'); 
const router = express.Router();
const notificationRouters = require('./notification.routes');
// Cấu hình lưu file
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads/'); // Thư mục lưu trữ file
    },
    filename: (req, file, cb) => {
      cb(null, Date.now() + '-' + file.originalname);
    }
});

// Tạo instance của multer với storage đã cấu hình
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 200 * 1024 * 1024 }  // Giới hạn file upload tối đa là 200MB
});

// Route để upload sản phẩm (Chú ý đường dẫn)
//router.post('/products', upload.single('imageFile'), ProductController.addProduct);
// Nhóm các routes với tiền tố `/api`
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/categories', categoryRoutes); 
router.use('/products', productRoutes); 
router.use('/variant-products', variantProductRoutes); 
router.use('/carts', cartRoutes); 
router.use('/promotions', promotionRoutes)
router.use('/orders', orderRoutes); 
router.use('/address', addressRoutes); 
router.use('/banners', bannerRoutes);
router.use('/shipping', shippingRoutes);
router.use('/admin', adminRoutes); 
router.use('/payments', paymentRoutes);
router.use('/contacts', contactRoutes)
router.use('/chat', chatbotRoutes);
router.use('/review', reviewRouters)
router.use('/notifications', notificationRouters);
module.exports = router;
