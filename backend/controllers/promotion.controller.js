const promotionService = require('../services/promotion.services');

const createPromotionCode = (req, res) => {
    console.log(req.body);
    promotionService.createPromotionCode(req.body, (error, result) => {
        if (error) {
            return res.status(500).json({ message: `Server Internal Error ${error.message}` });
        }
        return res.status(201).json({ result });
    });
};

const getPromotion = (req, res) => {

    console.log(req.body);
    promotionService.getPromotion((error, result) => {
        if (error) {
            return res.status(500).json({ message: `Server Internal Error ${error.message}` });
        }
        return res.status(200).json({ result });
    });
};

const getPrivatePromotion = (req, res) => {
    
    console.log(req.body);
    promotionService.getPrivatePromotion((error, result) => {
        if (error) {
            return res.status(500).json({ message: `Server Internal Error ${error.message}` });
        }
        return res.status(200).json({ result });
    });
};

const addPromotion = (req, res) => {
    try {
        const user_id = req.user?.id;
        const { promotion_id } = req.body;

        if (!user_id || !promotion_id) {
            return res.status(400).json({
                success: false,
                message: "Thiếu thông tin user hoặc promotion_id",
            });
        }

        promotionService.addPromotion({ user_id, promotion_id }, (error, result) => {
            if (error) {
                console.error("Lỗi khi thêm promotion:", error);
                return res.status(500).json({
                    success: false,
                    message: "Đã xảy ra lỗi nội bộ",
                });
            }

            return res.status(200).json(result);
        });
    } catch (err) {
        console.error("Lỗi server:", err);
        return res.status(500).json({
            success: false,
            message: "Lỗi server",
        });
    }
};

// Admin tăng promotion cho user 


const addPromotionForUser = (req, res) => {
    try {
        const user_id = req.params.id;
        console.log(user_id)
        // Get user_id params 
        //const user_param = req.id; 
        
        const { promotion_id } = req.body;

        if (!user_id || !promotion_id) {
            return res.status(400).json({
                success: false,
                message: "Thiếu thông tin user hoặc promotion_id",
            });
        }

        promotionService.giftPromotionByAdmin({ user_id, promotion_id }, (error, result) => {
            if (error) {
                console.error("Lỗi khi thêm promotion:", error);
                return res.status(500).json({
                    success: false,
                    message: "Đã xảy ra lỗi nội bộ",
                });
            }

            return res.status(200).json(result);
        });
    } catch (err) {
        console.error("Lỗi server:", err);
        return res.status(500).json({
            success: false,
            message: "Lỗi server",
        });
    }
};




const getUserPromotions = (req, res) => {
    const user_id = req.user?.id;

    if (!user_id) {
        return res.status(400).json({ message: "User ID is missing or invalid." });
    }

    promotionService.getUserPromotions(user_id, (error, result) => {
        if (error) {
            return res.status(500).json({ message: error.message });
        }

        return res.status(200).json(result);
    });
};

const getPromotionByCode = (req, res) => {
    const code = req.params.id;
    console.log(`Check code ${code} có tồn tại không ?   `)

    if (!code) {
        return res.status(400).json({
            success: false,
            message: "Promotion code is missing or invalid.",
        });
    }

    promotionService.getPromotionByCode(code, (error, result) => {
        if (error) {
            return res.status(500).json({
                success: false,
                message: `Server Internal Error: ${error.message}`,
            });
        }

        return res.status(200).json({ result });
    });
};

module.exports = {
    createPromotionCode,
    getPromotion,
    addPromotion,
    getUserPromotions,
    getPromotionByCode,
    getPrivatePromotion, 
    addPromotionForUser
};