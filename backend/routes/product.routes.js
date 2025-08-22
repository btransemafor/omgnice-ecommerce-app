const express = require('express');
const productController = require('../controllers/product.controller'); 
const { isAdmin } = require('../middleware');
const router = express.Router(); 
const validate_empty_body = require('../middleware/validate_empty_body'); 
const variantProductController = require('../controllers/variant_product.controller'); 
const multer = require('multer');
const reviewController = require('../controllers/review.controller');
//const {upload }= require('../middleware/multer_handle_image'); 
const {upload, safeSingleUpload} = require('../middleware/upload.middleware'); 
// const upload = multer({ 
//   limits: { fileSize: 200 * 1024 * 1024 }  // Giới hạn file upload tối đa là 200MB
// });





// Get allProduct 
router.get('/', productController.getAllProducts); 
router.get('/v2/', productController.fetchListProduct); 

router.put('/:id',validate_empty_body,  isAdmin, productController.updateProduct); 
router.post('/v2/:id',isAdmin, safeSingleUpload('image'),productController.updateProductNew ); 
router.delete('/:id', isAdmin, productController.deleteProduct); 
//router.post('/', validate_empty_body, isAdmin, productController.addProduct); 
router.post('/', isAdmin, upload.single('image'), productController.addProduct);
router.get('/:id/variants', variantProductController.getVariantByProductId);
router.get('/by-category/:category_id', productController.getProductByCategory); 
// Route tìm kiếm sản phẩm
router.get('/search', productController.searchProductController);
router.get('/:id', productController.getProductDetailById);
router.get('/:id/reviews', reviewController.getReviews); 

module.exports = router; 

