const shippingService = require('../services/shipping.services'); 
const getAllShipping = (req,res) => {
    shippingService.getShippingMethod((error, result) => {
        if (error) {
            return res.status(500).json({message: error.message}); 
        }
        if (!result.success) {
            return res.status(404).json(result);
        }
        return res.status(200).json(result); 
        
    })
}

module.exports = {
    getAllShipping, 
}