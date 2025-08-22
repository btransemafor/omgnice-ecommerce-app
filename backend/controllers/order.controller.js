const orderService = require('../services/order.services');  // Đảm bảo bạn import đúng file service

const getAllOrder = (req, res) => {
    const user_id = req.user.id;  // Xác thực phải đảm bảo req.user tồn tại và có giá trị id



    orderService.getAllOrder(user_id, (error, result) => {
        if (error) {
            console.error('Error from getAllOrder:', error.message);  // Debug nếu có lỗi
            return res.status(500).json({message: 'Server Internal Error'}); 
        }
        if (result.success == false) {
            return res.status(400).json({message: "Bad Request"}); 
        }
        return res.status(200).json(result); 
    });
}


// controllers/order.controller.js
const getOrderDetail = async (req, res) => {
    try {
      const userId = req.user.id; // authJwt
      const orderId = req.params.id;
  
      const order = await orderService.getOrderDetail(userId, orderId);
  
      if (!order) {
        return res.status(404).json({ message: 'Order not found' });
      }
  
      res.json(order);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server error' });
    }
  };
  


// Create Order 
const createOrder = (req, res) => {
    const user_id = req.user.id ; 
    
    req.body["orderInfo"].user_id = user_id; 
    const { orderInfo, products } = req.body;
    console.log( req.body); 
    //console.log(products); 

    orderService.createOrder(orderInfo, products, (error, result) => {  //  LỖI Ở ĐÂY
        if (error) {
            res.status(500).json(error);
        } else {
            res.status(201).json(result);
        }
    });
}


const getOrdersByStatus = async (req, res) => {
    try {
      const userId = req.user.id; 
      const status = req.query.status || 'processing';
  
      const orders = await orderService.getOrdersByStatus(userId, status);
      res.json(orders);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server error' });
    }
  };


// ------------------- Get All Order - Admin ------------------------ // 
const fetchAllOrders = async (req, res) => {
  orderService.fetchAllOrders((error, result) => {
    if (error) {
      return res.status(500).json({message: error.message})
    }
    return res.status(200).json(result)
  })
}

// ------ Update Trang thai order --------------- // 

const updateStatusOrder = async(req, res) => {
  try {
       // Lay du lieu can update 
   const update = req.body; 

   console.log(update); 
   // Get OrderID 
   const orderID = req.params.id; 
   if (orderID == null) {
    return res.status(404).json({message: "Khong tim thay order ID"}); 
   }
   console.log(orderID); 

   // Goi service 
   await orderService.updateOrderStatus(orderID, update); 
   return res.status(200).json({message: "Cập nhập trạng thái order thành công"}); 
  }
  catch(error) {
    return res.status(500).json({message: "Server Internal Error"}); 
  }
  
}

module.exports = {
    getAllOrder, 
    createOrder, 
    getOrdersByStatus, 
    getOrderDetail, 
    fetchAllOrders, 
    updateStatusOrder
};
