const {db} = require('../models/index'); 

const getCommentsByProduct = async (product_id, callback) => {
    try {
      const comments = await db.review.findAll({
        where: { product_id }, // lọc ở bảng review trước
        include: [
          {
            model: db.order_line,
            as: 'orderLine',
            attributes: ['order_id', 'user_id'],
            required: true,
          },
        ],
      });
      
      return callback(null, {
        message: "Get Comments Successfully",
        data: comments,
      });
    } catch (error) {
      return callback(error);
    }
  };
  
module.exports = {
    getCommentsByProduct
}