const express = require('express'); 
const router = express.Router();

const variantProductController = require('../controllers/variant_product.controller'); 

router.get('/', variantProductController.getAllVariantProduct); 

// routes/product.routes.js


module.exports = router; 