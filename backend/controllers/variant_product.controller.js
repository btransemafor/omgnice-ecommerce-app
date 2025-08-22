
const variantProductService = require('../services/variantProduct.services');

// [GET] /api/product-variants
const getAllVariantProduct = (req, res) => {
  variantProductService.getAllVariantProduct((err, result) => {
    if (err) {
      console.error("Lỗi khi lấy variant product:", err);
      return res.status(500).json({
        success: false,
        message: "Đã xảy ra lỗi khi truy vấn dữ liệu",
      });
    }

    return res.status(200).json(result); // result có { success, data, message }
  });
};




const getVariantByProductId = (req, res) => {
    const productId = req.params.id;
  
    variantProductService.getVariantByProductId(productId, (err, result) => {
      if (err) {
        console.error("Lỗi controller:", err);
        return res.status(500).json({
          success: false,
          message: "Lỗi server",
        });
      }
  
      res.status(200).json(result);
    });
  };
  
module.exports = {
    getAllVariantProduct, 
    getVariantByProductId
}
