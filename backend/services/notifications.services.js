/* // =======================
// 📁 services/notificationService.js
// =======================
const { db } = require("../models");

const getNotifications = async (user_id, callback) => {
  try {
    let whereCondition;
      whereCondition = {  
           user_id 
      };

    const notifications = await db.notification.findAll({
      where: whereCondition,
      order: [['createdAt', 'DESC']],
    });

    callback(null, notifications);
  } catch (error) {
    callback(error);
  }
};


const getAdminNotification = async (callback) => {
  try {
    const adminNotis = await db.adminNoti.findAll({
      order: [['createdAt', 'DESC']],
    });
    callback(null, adminNotis);
  } catch (error) {
    callback(error);
  }
};


const createNotiForAdmin = async ({ title, message, type = 'system' }) => {
  try {
    const newNotification = await db.adminNoti.create({
      title,
      message,
      type,
      status: false,    // mặc định chưa đọc
      read_at: null,
    });
    return newNotification;
  } catch (error) {
    console.error('Error creating admin notification:', error);
    throw error;
  }
};


const markAsRead = async (user_id, callback) => {
  try {
    await db.notification.update(
      { status: true, read_at: new Date() },
      { where: { user_id, status: false } }
    );

    return callback(null, {
      success: true,
      message: "Đã đánh dấu tất cả thông báo là đã đọc",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi đánh dấu đã đọc",
      error: error.message,
    });
  }
};

const markSingleAsRead = async (notification_id, user_id, callback) => {
  try {
    const result = await db.notification.update(
      { status: true, read_at: new Date() },
      { where: { id: notification_id, user_id } }
    );

    if (result[0] === 0) {
      return callback({
        success: false,
        message: "Không tìm thấy thông báo hoặc bạn không có quyền",
      });
    }

    return callback(null, {
      success: true,
      message: "Đã đánh dấu thông báo là đã đọc",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi đánh dấu thông báo",
      error: error.message,
    });
  }
};

const deleteNotification = async (notification_id, user_id, callback) => {
  try {
    console.log(`Đang xóa thông báo có id ${notification_id}`);
    const result = await db.notification.destroy({
      where: { id: notification_id, user_id },
    });

    if (result === 0) {
      return callback({
        success: false,
        message: "Không tìm thấy thông báo hoặc bạn không có quyền xoá",
      });
    }

    return callback(null, {
      success: true,
      message: "Đã xoá thông báo thành công",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi xoá thông báo",
      error: error.message,
    });
  }
};

const deleteAllNotifications = async (user_id, callback) => {
  try {
    await db.notification.destroy({ where: { user_id } });
    return callback(null, {
      success: true,
      message: "Đã xoá tất cả thông báo thành công",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi xoá toàn bộ thông báo",
      error: error.message,
    });
  }
};

const createNotification = async (notificationData, callback) => {
  try {
    // Nếu là broadcast thì gửi đến tất cả user
    console.log(notificationData);
    if (notificationData.broadcast === "true") {
      const allUsers = await db.user.findAll({ attributes: ["id"] });

      const notifications = allUsers.map((user) => ({
        user_id: user.id,
        title: notificationData.title,
        message: notificationData.message,
        type: notificationData.type || "system",
        status: false,
        read_at: null,
        createdAt: new Date(),
        updatedAt: new Date()
      }));

      await db.notification.bulkCreate(notifications);

      return callback(null, {
        success: true,
        message: "Gửi thông báo đến toàn bộ người dùng thành công",
      });
    }

    // Nếu không phải broadcast thì chỉ gửi cho 1 người
    if (!notificationData.user_id) {
      return callback({
        success: false,
        message: "Thiếu user_id để gửi riêng hoặc không bật chế độ broadcast",
      });
    }

    const newNotification = await db.notification.create({
      user_id: notificationData.user_id,
      title: notificationData.title,
      message: notificationData.message,
      type: notificationData.type || "system",
      status: false,
      read_at: null,
    });

    console.log(`Đã tạo dữ liệu thành công ${newNotification}`);

    return callback(null, {
      success: true,
      message: "Tạo thông báo thành công",
      data: newNotification,
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi tạo thông báo",
      error: error.message,
    });
  }
};

module.exports = {
  getNotifications,
  markAsRead,
  markSingleAsRead,
  deleteNotification,
  deleteAllNotifications,
  createNotification,
  getAdminNotification,
  createNotiForAdmin
};
 */


const { db } = require("../models");

// Hàm chung để đánh dấu tất cả thông báo chưa đọc là đã đọc
const markAsReadGeneric = async (model, user_id, callback) => {
  try {
    const whereCondition = model === db.adminNoti ? {} : { user_id, status: false };
    await model.update(
      { status: true, read_at: new Date() },
      { where: whereCondition }
    );

    return callback(null, {
      success: true,
      message: "Đã đánh dấu tất cả thông báo là đã đọc",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi đánh dấu đã đọc",
      error: error.message,
    });
  }
};

// Hàm chung để đánh dấu một thông báo cụ thể là đã đọc
const markSingleAsReadGeneric = async (model, notification_id, user_id, callback) => {
  try {
    const whereCondition = model === db.adminNoti
      ? { id: notification_id }
      : { id: notification_id, user_id };

    const result = await model.update(
      { status: true, read_at: new Date() },
      { where: whereCondition }
    );

    if (result[0] === 0) {
      return callback({
        success: false,
        message: "Không tìm thấy thông báo hoặc bạn không có quyền",
      });
    }

    return callback(null, {
      success: true,
      message: "Đã đánh dấu thông báo là đã đọc",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi đánh dấu thông báo",
      error: error.message,
    });
  }
};

// Hàm chung để xóa một thông báo cụ thể
const deleteNotificationGeneric = async (model, notification_id, user_id, callback) => {
  try {
    const whereCondition = model === db.adminNoti 
      ? { id: notification_id }
      : { id: notification_id, user_id };

    const result = await model.destroy({ where: whereCondition });

    if (result === 0) {
      return callback({
        success: false,
        message: "Không tìm thấy thông báo hoặc bạn không có quyền xoá",
      });
    }

    return callback(null, {
      success: true,
      message: "Đã xoá thông báo thành công",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi xoá thông báo",
      error: error.message,
    });
  }
};

// Hàm chung để xóa tất cả thông báo
const deleteAllNotificationsGeneric = async (model, user_id, callback) => {
  try {
    const whereCondition = model === db.adminNoti ? {} : { user_id };
    await model.destroy({ where: whereCondition });

    return callback(null, {
      success: true,
      message: "Đã xoá tất cả thông báo thành công",
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi xoá toàn bộ thông báo",
      error: error.message,
    });
  }
};

// Lấy thông báo của user
const getNotifications = async (user_id, callback) => {
  try {
    const notifications = await db.notification.findAll({
      where: { user_id },
      order: [['createdAt', 'DESC']],
    });

    callback(null, notifications);
  } catch (error) {
    callback(error);
  }
};

// Lấy thông báo của admin
const getAdminNotification = async (callback) => {
  try {
    const adminNotis = await db.adminNoti.findAll({
      order: [['createdAt', 'DESC']],
    });
    callback(null, adminNotis);
  } catch (error) {
    callback(error);
  }
};

// Tạo thông báo cho admin
const createNotiForAdmin = async ({ title, message, type = 'system' }) => {
  try {
    const newNotification = await db.adminNoti.create({
      title,
      message,
      type,
      status: false,
      read_at: null,
    });
    return newNotification;
  } catch (error) {
    console.error('Error creating admin notification:', error);
    throw error;
  }
};

// Đánh dấu tất cả thông báo user là đã đọc
const markAsRead = async (user_id, callback) => {
  return markAsReadGeneric(db.notification, user_id, callback);
};

// Đánh dấu một thông báo user cụ thể là đã đọc
const markSingleAsRead = async (notification_id, user_id, callback) => {
  return markSingleAsReadGeneric(db.notification, notification_id, user_id, callback);
};

// Xóa một thông báo user cụ thể
const deleteNotification = async (notification_id, user_id, callback) => {
  return deleteNotificationGeneric(db.notification, notification_id, user_id, callback);
};

// Xóa tất cả thông báo của user
const deleteAllNotifications = async (user_id, callback) => {
  return deleteAllNotificationsGeneric(db.notification, user_id, callback);
};

// Đánh dấu tất cả thông báo admin là đã đọc
const markAdminNotiAsRead = async (callback) => {
  return markAsReadGeneric(db.adminNoti, null, callback);
};

// Đánh dấu một thông báo admin cụ thể là đã đọc
const markSingleAdminNotiAsRead = async (notification_id, callback) => {
  return markSingleAsReadGeneric(db.adminNoti, notification_id, null, callback);
};

// Xóa một thông báo admin cụ thể
const deleteAdminNotification = async (notification_id, callback) => {
  return deleteNotificationGeneric(db.adminNoti, notification_id, null, callback);
};

// Xóa tất cả thông báo admin
const deleteAllAdminNotifications = async (callback) => {
  return deleteAllNotificationsGeneric(db.adminNoti, null, callback);
};

// Tạo thông báo cho user hoặc broadcast
const createNotification = async (notificationData, callback) => {
  try {
    if (notificationData.broadcast === "true") {
      const allUsers = await db.user.findAll({ attributes: ["id"] });

      const notifications = allUsers.map((user) => ({
        user_id: user.id,
        title: notificationData.title,
        message: notificationData.message,
        type: notificationData.type || "system",
        status: false,
        read_at: null,
        createdAt: new Date(),
        updatedAt: new Date(),
      }));

      await db.notification.bulkCreate(notifications);

      return callback(null, {
        success: true,
        message: "Gửi thông báo đến toàn bộ người dùng thành công",
      });
    }

    if (!notificationData.user_id) {
      return callback({
        success: false,
        message: "Thiếu user_id để gửi riêng hoặc không bật chế độ broadcast",
      });
    }

    const newNotification = await db.notification.create({
      user_id: notificationData.user_id,
      title: notificationData.title,
      message: notificationData.message,
      type: notificationData.type || "system",
      status: false,
      read_at: null,
    });

    return callback(null, {
      success: true,
      message: "Tạo thông báo thành công",
      data: newNotification,
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi khi tạo thông báo",
      error: error.message,
    });
  }
};

module.exports = {
  getNotifications,
  getAdminNotification,
  createNotiForAdmin,
  createNotification,
  markAsRead,
  markSingleAsRead,
  deleteNotification,
  deleteAllNotifications,
  markAdminNotiAsRead,
  markSingleAdminNotiAsRead,
  deleteAdminNotification,
  deleteAllAdminNotifications,
};
