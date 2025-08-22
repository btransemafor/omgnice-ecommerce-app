const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notification.controller');
const { isAdmin } = require('../middleware');

// ======================= USER NOTIFICATIONS =======================

// Lấy danh sách thông báo của user
router.get('/', notificationController.fetchNotifications);

// Tạo thông báo cho user hoặc broadcast
router.post('/', notificationController.createNotifications);

// Đánh dấu tất cả thông báo user là đã đọc
router.patch('/read-all', notificationController.markAllAsRead);

// Đánh dấu một thông báo user là đã đọc
router.patch('/:notificationId/read', notificationController.markOneAsRead);

// Xóa một thông báo user
// Xóa tất cả thông báo admin
router.delete('/admin', isAdmin, notificationController.deleteAllAdminNotifications);

router.delete('/:notificationId', notificationController.deleteNotification);

// Xóa tất cả thông báo của user
router.delete('/', notificationController.deleteAllNotifications);

// ======================= ADMIN NOTIFICATIONS =======================

// Lấy danh sách thông báo của admin
router.get('/admin', isAdmin, notificationController.getAdminNotification);

// Tạo thông báo cho admin
router.post('/admin', isAdmin, notificationController.createAdminNotification);

// Đánh dấu tất cả thông báo admin là đã đọc
router.patch('/admin/read-all', isAdmin, notificationController.markAllAdminNotiAsRead);

// Đánh dấu một thông báo admin là đã đọc
router.patch('/admin/:notificationId/read', isAdmin, notificationController.markOneAdminNotiAsRead);

// Xóa một thông báo admin
router.delete('/admin/:notificationId', isAdmin, notificationController.deleteAdminNotification);


module.exports = router;