const statisticsController = require("../controllers/admin/statistics.controller"); 
const express = require('express'); 
const { isAdmin } = require('../middleware');
const router = express.Router(); 

router.get('/category/', isAdmin, statisticsController.getQuantitySaleOfCategory); 
router.get('/revenue-last7Days/',isAdmin,  statisticsController.getRevenueLast7Days); 
router.get('/dashboard-overview',isAdmin, statisticsController.getDashboardOverviewController); 
module.exports = router; 