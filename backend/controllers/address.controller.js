const addressService = require('../services/address.services'); 

const createnewAddress = (req, res ) => {
    // get id user from middle auth 
    const user_id = req.user.id; 

    const newAddress = req.body; 

    // Them user_id 
    newAddress.user_id = user_id; 

    console.log(newAddress); 
    
    addressService.createAddress(newAddress, (err , result ) => {
        if (err) {
            return res.status(500).json(err);
        }
        return res.status(200).json(result); 
    }) ;
}
const updateAddress = (req, res) => {
  try {
    const user_id = req.user.id;
    const id = req.params.id; 
    if (!user_id) {
      return res.status(401).json({
        success: false,
        message: "Không xác thực được người dùng.",
      });
    }

    const newAddress = {
      ...req.body,
      user_id,
      id // Gắn user_id vào object gửi qua service
    };

    addressService.updateAddress(newAddress, (err, result) => {
      if (err) {
        console.error("Lỗi update address:", err);
        return res.status(500).json({
          success: false,
          message: "Lỗi server khi cập nhật địa chỉ!",
          error: err.message || err,
        });
      }

      if (!result || result.success === false) {
        return res.status(400).json(result); // Trả về message thất bại từ service
      }

      return res.status(200).json(result);
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Đã xảy ra lỗi không xác định.",
      error: error.message,
    });
  }
};

const fetchListAddress = (req, res) => {
  
  const requestedUserId = req.params.id || req.user.id;

  console.log('👤 token user:', req.user.id);
  console.log('🔍 param user:', req.params.userId);
  console.log('✅ using userId to fetch:', requestedUserId);

  if (requestedUserId !== req.user.id && req.user.role_id !== 2 ) {
    return res.status(403).json({
      success: false,
      message: 'Bạn không có quyền truy cập địa chỉ người dùng khác!',
    });
  }
  addressService.fetchListAddress(requestedUserId, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message || 'Lỗi khi lấy danh sách địa chỉ!',
      });
    }

    return res.status(200).json(result); // result = { success, message, data }
  });
};

  
  const deleteAddress = (req, res) => {
    const user_id = req.user?.id;
    if (!user_id) {
      return res.status(404).json({ message: "Not Found User" });
    }
  
    const id = req.params.id;
  
    addressService.deleteAddress({ user_id, id }, (error, result) => {
      if (error) {
        return res.status(500).json({ message: error.message || 'Internal server error' });
      }
  
      if (!result || result.success === false) {
        return res.status(404).json({
          success: false,
          message: result?.message || "Address not found",
        });
      }
  
      return res.status(200).json(result);
    });
  };
  
module.exports = {
    createnewAddress, 
    updateAddress, 
    fetchListAddress, 
    deleteAddress
}