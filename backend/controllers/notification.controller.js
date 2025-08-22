/* // ===================== CONTROLLER =====================
const notificationService = require("../services/notifications.services");

const fetchNotifications = (req, res) => {
  // Ưu tiên lấy userId truyền qua query, nếu không thì lấy user đang đăng nhập
  const user_id = req.query.userId || req.user.id;

  notificationService.getNotifications(user_id, (error, result) => {
    if (error) {
      return res.status(500).json(error);
    }
    return res.status(200).json(result);
  });
};

const getAdminNotification = (req, res) => {
  notificationService.getAdminNotification((error, result) => {
    if (error) {
      return res.status(500).json({ message: 'Error fetching admin notifications', error });
    }
    return res.status(200).json(result);
  });
};


const markAllAsRead = (req, res) => {
  const user_id = req.user.id;

  notificationService.markAsRead(user_id, (error, result) => {
    if (error) return res.status(500).json(error);
    return res.status(200).json(result);
  });
};

const markOneAsRead = (req, res) => {
  const user_id = req.user.id;
  const { notificationId } = req.params;

  notificationService.markSingleAsRead(
    notificationId,
    user_id,
    (error, result) => {
      if (error) return res.status(500).json(error);
      return res.status(200).json(result);
    }
  );
};

const deleteNotification = (req, res) => {
  const user_id = req.user.id;
  const { notificationId } = req.params;

  notificationService.deleteNotification(
    notificationId,
    user_id,
    (error, result) => {
      if (error) return res.status(500).json(error);
      return res.status(200).json(result);
    }
  );
};

const deleteAllNotifications = (req, res) => {
  const user_id = req.user.id;

  notificationService.deleteAllNotifications(user_id, (error, result) => {
    if (error) return res.status(500).json(error);
    return res.status(200).json(result);
  });
};

const createNotifications = (req, res) => {

  const { title, message, user_id, broadcast } = req.body; 

  console.log(`${title}, ${message}, ${user_id}, ${broadcast}`)




  
  notificationService.createNotification(req.body, (error, result) => {
    if (error) return res.status(500).json(error);
    return res.status(200).json(result);
  });
};

module.exports = {
  fetchNotifications,
  markAllAsRead,
  markOneAsRead,
  deleteNotification,
  deleteAllNotifications,
  createNotifications, 
  getAdminNotification
};
 */



const notificationService = require("../services/notifications.services");

const fetchNotifications = (req, res) => {
  const user_id = req.query.userId || req.user.id;
  console.log(`Fetching notifications for user_id: ${user_id}`);

  notificationService.getNotifications(user_id, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: "Lỗi khi lấy thông báo",
        error: error.message || error,
      });
    }
    return res.status(200).json({
      success: true,
      data: result,
    });
  });
};

const getAdminNotification = (req, res) => {
  console.log("Fetching admin notifications");

  notificationService.getAdminNotification((error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: "Lỗi khi lấy thông báo admin",
        error: error.message || error,
      });
    }
    return res.status(200).json({
      success: true,
      data: result,
    });
  });
};

const markAllAsRead = (req, res) => {
  const user_id = req.user.id;
  console.log(`Marking all notifications as read for user_id: ${user_id}`);

  notificationService.markAsRead(user_id, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi đánh dấu đã đọc",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const markOneAsRead = (req, res) => {
  const user_id = req.user.id;
  const { notificationId } = req.params;
  console.log(`Marking notification ${notificationId} as read for user_id: ${user_id}`);

  notificationService.markSingleAsRead(notificationId, user_id, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi đánh dấu thông báo",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const deleteNotification = (req, res) => {
  const user_id = req.user.id;
  const { notificationId } = req.params;
  console.log(`Deleting notification ${notificationId} for user_id: ${user_id}`);

  notificationService.deleteNotification(notificationId, user_id, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi xóa thông báo",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const deleteAllNotifications = (req, res) => {
  const user_id = req.user.id;
  console.log(`Deleting all notifications for user_id: ${user_id}`);

  notificationService.deleteAllNotifications(user_id, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi xóa tất cả thông báo",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const createNotifications = (req, res) => {
  const { title, message, user_id, broadcast } = req.body;
  console.log(`Creating notification: title=${title}, message=${message}, user_id=${user_id}, broadcast=${broadcast}`);

  notificationService.createNotification(req.body, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi tạo thông báo",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
      data: result.data,
    });
  });
};

const createAdminNotification = (req, res) => {
  const { title, message, type } = req.body;
  console.log(`Creating admin notification: title=${title}, message=${message}, type=${type}`);

  notificationService.createNotiForAdmin({ title, message, type }, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: "Lỗi khi tạo thông báo admin",
        error: error.message || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: "Tạo thông báo admin thành công",
      data: result,
    });
  });
};

const markAllAdminNotiAsRead = (req, res) => {
  console.log("Marking all admin notifications as read");

  notificationService.markAdminNotiAsRead((error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi đánh dấu tất cả thông báo admin",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const markOneAdminNotiAsRead = (req, res) => {
  const { notificationId } = req.params;
  console.log(`Marking admin notification ${notificationId} as read`);

  notificationService.markSingleAdminNotiAsRead(notificationId, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi đánh dấu thông báo admin",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const deleteAdminNotification = (req, res) => {
  const { notificationId } = req.params;
  console.log(`Deleting admin notification ${notificationId}`);

  notificationService.deleteAdminNotification(notificationId, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi xóa thông báo admin",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

const deleteAllAdminNotifications = (req, res) => {
  console.log("Deleting all admin notifications");

  notificationService.deleteAllAdminNotifications((error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || "Lỗi khi xóa tất cả thông báo admin",
        error: error.error || error,
      });
    }
    return res.status(200).json({
      success: true,
      message: result.message,
    });
  });
};

module.exports = {
  fetchNotifications,
  getAdminNotification,
  createNotifications,
  createAdminNotification,
  markAllAsRead,
  markOneAsRead,
  deleteNotification,
  deleteAllNotifications,
  markAllAdminNotiAsRead,
  markOneAdminNotiAsRead,
  deleteAdminNotification,
  deleteAllAdminNotifications,
}