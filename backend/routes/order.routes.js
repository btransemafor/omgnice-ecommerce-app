const express = require("express");
const router = express.Router();
const orderController = require("../controllers/order.controller");
const { isAdmin } = require("../middleware");

router.get("/", orderController.getAllOrder);
router.post("/", orderController.createOrder);
router.put("/:id", orderController.updateStatusOrder);
router.get("/", orderController.getOrdersByStatus);
// routes/order.route.js
router.get("/:id", orderController.getOrderDetail);
// Lọc tất cả đơn hàng của user

module.exports = router;
