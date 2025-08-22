// ================================
// 5. chatbot.routes.js
// ================================
const express = require('express');
const router = express.Router();
const { askChatbot } = require('../controllers/chatbot.controller');

router.post('/', askChatbot);

module.exports = router;