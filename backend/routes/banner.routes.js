const bannerController = require('../controllers/banner.controller');
const express = require('express');
const router = express.Router();

router.get('/', bannerController.getbanners);
router.post('/', bannerController.createBanner); 
router.delete('/:id', bannerController.deleteBanner);
module.exports = router;