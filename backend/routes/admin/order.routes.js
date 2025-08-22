const express = require('express'); 
const router = express.Router(); 
const orderController = require('../../controllers/order.controller'); 
const { isAdmin } = require('../../middleware');
router.use('/', isAdmin, orderController.fetchAllOrders);
module.exports = router; 