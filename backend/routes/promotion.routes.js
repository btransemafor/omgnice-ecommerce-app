const promotionController = require('../controllers/promotion.controller'); 
const express = require('express'); 

const router = express.Router(); 
const { isAdmin } = require('../middleware');
// 

router.post('/', promotionController.addPromotion); 
router.post('/create', isAdmin, promotionController.createPromotionCode); 
router.get('/', promotionController.getUserPromotions);
router.get('/private', isAdmin, promotionController.getPrivatePromotion)
router.get('/public', promotionController.getPromotion); 
router.get('/public/:id', promotionController.getPromotionByCode); 
router.post('/:id', isAdmin, promotionController.addPromotionForUser); 
// Search sản phẩm (kết hợp query + filter + phân trang)

module.exports = router; 