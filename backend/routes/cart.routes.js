const express = require('express');
const cartController = require('../controllers/cart.controller'); 

const router = express.Router();

router.get('/', cartController.getCart); 
router.get('/:user_id', cartController.getCartByUserid); 
router.post('/', cartController.addProductToCart); 
router.delete('/:cartItemId', cartController.deleteCartItem); 
router.put('/:cartItemId', cartController.updateCart); 
module.exports = router; 