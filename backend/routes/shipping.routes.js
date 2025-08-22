const express = require('express'); 
 
const shippingMethodController = require('../controllers/shipping.controller');
const router = express.Router(); 
router.get('/', shippingMethodController.getAllShipping ); 

module.exports = router; 