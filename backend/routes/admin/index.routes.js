// Nhóm với tiền tố admin 
const express = require('express'); 
const router = express.Router(); 
const statisticsRoute = require('../statistic.routes'); 
const productRoute = require('../product.routes'); 
const orderRoute = require('../admin/order.routes'); 
const { isAdmin } = require('../../middleware');
router.use('/statistics', statisticsRoute);  
router.use('/orders', orderRoute); 
// Nhom Order cua admin 
// Statistic 
// Product 
// Orders 
// Customer 

module.exports = router; 