const cartService = require('../services/cart.services');  // Đường dẫn đến file service của bạn

// Lấy dữ liệu Cart theo user_id
const getCartByUserid = (req, res) => {
    const userId = req.params.user_id;

    console.log(userId);

    cartService.getCartByUserid(userId, (error, result) => {
        if (error) {
            return res.status(500).json({ success: false, message: error });
        }

        if (!result.success) {
            return res.status(404).json({ success: false, message: 'Not Found Item In Your Cart' });
        }

        return res.status(200).json({ success: true, data: result }); 
    });
}


const getCart = (req, res) => {
    const user_id = req.user.id ; 
    cartService.getCartByUserid(user_id, (error, result) => {
        if (error) {
            return res.status(500).json({ success: false, message: error });
        }

        if (!result.success) {
            return res.status(404).json({ success: false, message: 'Not Found Item In Your Cart' });
        }

        return res.status(200).json({ success: true, data: result }); 
    });

}

const addProductToCart = (req, res) => {
    const dataCartItem = req.body; 
    const user_id = req.user.id ; 

    dataCartItem.user_id = user_id; 
    cartService.addProductToCart(dataCartItem,(error,result) => {
        if (error) {
            return res.status(500).json({ success: false, message: error });
        }
        return res.status(201).json(result); 
    })
}


const deleteCartItem = (req, res) => {
    const cartItemId  = req.params.cartItemId; // Lấy dữ liệu từ request body
    console.log(cartItemId); 
    
    cartService.deleteCartItem(cartItemId , (error, result) => {
        if (error) {
            return res.status(500).json({
                success: false,
                message: 'Internal Server Error',
                error: error.message
            });
        }

        return res.status(200).json(result); // Trả về kết quả của service
    });
};




const updateCart = (req, res) => {
    const data = req.body;
    const cartItemId = req.params.cartItemId;

    // Kiểm tra dữ liệu đầu vào tối thiểu
    if (!cartItemId) {
        return res.status(400).json({ message: 'Cart item ID is required.' });
    }

    cartService.updateCart(data, cartItemId, (error, result) => {
        if (error) {
            return res.status(500).json({ message: error.message || 'Internal Server Error' });
        }

        if (!result?.success) {
            return res.status(404).json(result);
        }

        return res.status(200).json(result);
    });
};

module.exports = {
    getCartByUserid,
    addProductToCart, 
    getCart , 
    deleteCartItem, 
    updateCart
}
