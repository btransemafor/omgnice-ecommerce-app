const express = require('express'); 
const router = express.Router(); 
const multer = require("multer");
const upload = multer(); // Sử dụng bộ nhớ RAM, không lưu file
const contactController = require('../controllers/contact.controller'); 

router.post('/',  upload.single('attachment'), contactController.sendContact );
module.exports = router; 