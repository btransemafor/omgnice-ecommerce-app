const reviewService = require('../services/review.services'); 

const createReview = async (req,res) => {
    // Get user_id 
    const user_id = req.user.id ; 
    console.log(user_id);
    const data = req.body; 
    const {order_line_id, rating_star, comment} = data;
    
    if (!order_line_id || !rating_star || !comment) {
        return res.status(400).json({
            message: "Vui lòng cung cấp đủ thông tin để tiến hành review"
        }); 
    }

    console.log(data); 

    reviewService.createReview({user_id, order_line_id, rating_star, comment }, (error, result) => {
        if (error) {
            return res.status(500).json({message: "Server Error Internal"}); 
        }
        else if (!result.success) {
            return res.status(403).json(result);
        }
        return res.status(201).json(result);
    })
}


const getReviews = async (req,res) => {
    // Get ID Product tren url params 
    const product_id = req.params.id; 
    if (!product_id) {
        return res.status(400).json({
            message: "Bad Request"
        }); 
    }

    reviewService.getReviews(product_id, (error, result) => {
        if (error) {
            return res.status(500).json(error); 
        }
        return res.status(200).json(result)
    })
}
module.exports = {
    createReview, 
    getReviews
}