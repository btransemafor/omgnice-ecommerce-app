const { db } = require("../../models/index");
const { Op } = require("sequelize");
const moment = require("moment-timezone");

/**
 * Lấy thống kê doanh số theo danh mục sản phẩm
 * @param {Object} options
 * @param {string} [options.from] - Ngày bắt đầu (YYYY-MM-DD)
 * @param {string} [options.to] - Ngày kết thúc (YYYY-MM-DD)
 * @returns {Promise<Array<{ name_category: string, sold_quantity: number, sale: number }>>}
 */
const getStatisticCategory = async ({ from, to } = {}) => {
  const where = {};

  if (from || to) {
    const fromDate = from ? moment.tz(from, "Asia/Ho_Chi_Minh").toDate() : null;
    const toDate = to ? moment.tz(to, "Asia/Ho_Chi_Minh").toDate() : null;

    if (fromDate && isNaN(fromDate.getTime()))
      throw new Error("Invalid from date format");
    if (toDate && isNaN(toDate.getTime()))
      throw new Error("Invalid to date format");

    where[Op.and] = [
      db.sequelize.where(db.sequelize.col("order.orderDate"), {
        ...(fromDate && { [Op.gte]: fromDate }),
        ...(toDate && { [Op.lte]: toDate }),
      }),
    ];
  }

  const rawResults = await db.order_line.findAll({
    where,
    attributes: [
      [db.sequelize.col("product.category.category_name"), "name_category"],
      [
        db.sequelize.fn("SUM", db.sequelize.col("order_line.quantity")),
        "sold_quantity",
      ],
      [
        db.sequelize.literal("SUM(order_line.quantity * order_line.price)"),
        "sale",
      ],
    ],
    include: [
      {
        model: db.product,
        as: "product",
        attributes: [],
        include: [
          {
            model: db.category,
            as: "category",
            attributes: [],
          },
        ],
      },
      {
        model: db.order,
        as: "order",
        attributes: [],
      },
    ],
    group: ["product.category.category_name"],
    raw: true,
  });

  return rawResults.map((r) => ({
    name_category: r.name_category,
    sold_quantity: parseInt(r.sold_quantity || 0, 10),
    sale: parseFloat(r.sale || 0),
  }));
};

/**
 * Alias nếu cần gọi với tên khác
 */
const getQuantitySaleOfCategory = getStatisticCategory;

// Get Tong Doanh Thu cua Last 7days

/**
 * Lấy xu hướng doanh thu theo ngày trong khoảng thời gian
 * @param {Object} options
 * @param {string} options.start - Ngày bắt đầu (YYYY-MM-DD)
 * @param {string} options.end - Ngày kết thúc (YYYY-MM-DD)
 * @returns {Promise<Array<{ orderDate: string, totalRevenue: number }>>}
 */
const getRevenueTrendByDateRange = async ({ start, end } = {}) => {
  if (!start || !end) {
    throw new Error("Vui lòng cung cấp start và end date.");
  }

  const startDate = moment.tz(start, "Asia/Ho_Chi_Minh").toDate();
  const endDate = moment.tz(end, "Asia/Ho_Chi_Minh").toDate();

  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    throw new Error("Định dạng ngày không hợp lệ.");
  }
  if (startDate > endDate) {
    throw new Error("Ngày bắt đầu phải trước ngày kết thúc.");
  }

  const where = {
    [Op.and]: [
      db.sequelize.where(db.sequelize.col("orderDate"), {
        [Op.gte]: startDate,
        [Op.lte]: endDate,
      }),
      { paymentStatus: true }, // Chỉ tính các đơn hàng đã thanh toán
    ],
  };

  const revenueData = await db.order.findAll({
    where,
    attributes: [
      [
        db.sequelize.fn("TO_CHAR", db.sequelize.col("orderDate"), "YYYY-MM-DD"),
        "orderDate",
      ],
      [db.sequelize.fn("SUM", db.sequelize.col("orderTotal")), "totalRevenue"],
    ],
    group: [
      db.sequelize.fn("TO_CHAR", db.sequelize.col("orderDate"), "YYYY-MM-DD"),
    ],
    order: [[db.sequelize.col("orderDate"), "ASC"]],
    raw: true,
  });

  return revenueData.map((r) => ({
    orderDate: r.orderDate,
    totalRevenue: parseFloat(r.totalRevenue || 0),
  }));
};

/**
 * Lấy số lượng đơn hàng theo ngày trong khoảng thời gian
 * @param {Object} options
 * @param {string} options.start - Ngày bắt đầu (YYYY-MM-DD)
 * @param {string} options.end - Ngày kết thúc (YYYY-MM-DD)
 * @returns {Promise<Array<{ month: string, order_count: number }>>}
 */
const getOrdersByDateRange = async ({ start, end } = {}) => {
  if (!start || !end) {
    throw new Error("Vui lòng cung cấp start và end date.");
  }

  const startDate = moment.tz(start, "Asia/Ho_Chi_Minh").toDate();
  const endDate = moment.tz(end, "Asia/Ho_Chi_Minh").toDate();

  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    throw new Error("Định dạng ngày không hợp lệ.");
  }
  if (startDate > endDate) {
    throw new Error("Ngày bắt đầu phải trước ngày kết thúc.");
  }

  const where = {
    [Op.and]: [
      db.sequelize.where(db.sequelize.col("orderDate"), {
        [Op.gte]: startDate,
        [Op.lte]: endDate,
      }),
      { paymentStatus: true }, // Chỉ tính các đơn hàng đã thanh toán
    ],
  };

  const orderData = await db.Order.findAll({
    where,
    attributes: [
      [
        db.sequelize.fn(
          "DATE_FORMAT",
          db.sequelize.col("orderDate"),
          "%Y-%m-%d"
        ),
        "month",
      ],
      [db.sequelize.fn("COUNT", db.sequelize.col("id")), "order_count"],
    ],
    group: [
      db.sequelize.fn("DATE_FORMAT", db.sequelize.col("orderDate"), "%Y-%m-%d"),
    ],
    raw: true,
  });

  return orderData.map((r) => ({
    month: r.month,
    order_count: parseInt(r.order_count || 0, 10),
  }));
};



const getDashboardOverview = async ({ from, to } = {}, callback) => {
  const orderDateRange = {};
  const userDateRange = {};

  // Xử lý startDate, endDate để đảm bảo chính xác
  const startDate = moment
    .tz(from, "Asia/Ho_Chi_Minh")
    .startOf("day")
    .toDate();
  const endDate = moment
    .tz(to, "Asia/Ho_Chi_Minh")
    .endOf("day")
    .toDate();

  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    throw new Error("Định dạng ngày không hợp lệ.");
  }
  if (startDate > endDate) {
    throw new Error("Ngày bắt đầu phải trước ngày kết thúc.");
  }

  if (from && to) {
    orderDateRange.orderDate = {
      [Op.between]: [startDate, endDate],
    };

    userDateRange.createdAt = {
      [Op.between]: [startDate, endDate],
    };
  }

  // Đặt các Promise cho các yêu cầu API
  const totalOrderPromise = db.order.count({ where: orderDateRange });
  const totalCustomerPromise = db.user.count({ where: userDateRange });
  
  // Get totalProcessingOrder => orderStatus là 'processing'
  const totalProcessingOrder = db.order.count({
    where: { ...orderDateRange, orderStatus: 'pending' },
  });

  // Get totalCompletedOrder => orderStatus là 'completed'
  const totalCompletedOrder = db.order.count({
    where: { ...orderDateRange, orderStatus: 'completed' },
  });

  // Get orderValueTotal - Tổng giá trị đơn hàng, bao gồm cả đơn chưa thanh toán
  const revenueSale = db.order.sum("orderTotal", {
    where: { ...orderDateRange, paymentStatus: true },
  }); 

  const orderValueTotal = await db.order.sum("orderTotal", {
    where: { ...orderDateRange, orderTotal: { [Op.ne]: null }},
  });
  
  console.log('Total Order Value:', orderValueTotal);
  
  // Thực hiện tất cả Promise cùng lúc
  const [
    totalOrders,
    processingOrders,
    completedOrders,
    totalCustomers,
    totalRevenue,
    orderValue
  ] = await Promise.all([
    totalOrderPromise,
    totalProcessingOrder,
    totalCompletedOrder,
    totalCustomerPromise,
    revenueSale,
    orderValueTotal
  ]);

  // Trả về kết quả hoặc tiếp tục với callback tùy nhu cầu
  callback(null, {
    totalOrders,
    processingOrders,
    completedOrders,
    totalCustomers,
    totalRevenue,
    orderValueTotal,
  });
};


module.exports = {
  getStatisticCategory,
  getQuantitySaleOfCategory,
  getRevenueTrendByDateRange,
  getDashboardOverview
};
