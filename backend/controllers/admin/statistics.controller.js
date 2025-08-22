
// Lấy số lượng sản phẩm đã bán được và danh số theo category 
const statisticService = require('../../services/admin/statistic.services'); 

const getQuantitySaleOfCategory = async (req, res) => {
    try {
      const { from, to } = req.query;
      console.log('Từ ngày:', from, ' đến ngày:', to); 
      const result = await statisticService.getStatisticCategory({ from, to });
  
     //  KHÔNG dùng .get vì đây là plain object
    const formatted = result.map(r => ({
      name: r.name_category,
      quantity: r.sold_quantity,
      total_sale: r.sale,
    }));
  
      return res.status(200).json(formatted);
    } catch (error) {
      console.error(" Lỗi thống kê:", error);
      res.status(500).json({ message: 'Lỗi thống kê', error });
    }
  };
  

  const getRevenueLast7Days = async (req, res) => {
    try {
      // Tham số từ query (có thể có từ và đến ngày, nếu không sẽ tính từ 7 ngày trước đến hôm nay)
      const { start, end } = req.query;
      console.log('Từ ngày:', start, ' đến ngày:',end); 
  
      // Nếu không có từ ngày và đến ngày, mặc định sẽ tính từ 7 ngày trước
      const result = await statisticService.getRevenueTrendByDateRange({ start, end });
      
      // Định dạng lại kết quả cho dễ sử dụng
      const formatted = result.map(r => ({
        date: r.orderDate, // Ngày bán
        total_revenue: r.totalRevenue, // Doanh thu
      }));
      
      // Trả về kết quả dưới dạng JSON
      return res.status(200).json(formatted);
    } catch (error) {
      console.error("Lỗi thống kê doanh thu trong 7 ngày:", error);
      return res.status(500).json({ message: 'Lỗi thống kê doanh thu trong 7 ngày', error });
    }
  };

// Controller để gọi getDashboardOverview và trả kết quả
const getDashboardOverviewController = async (req, res) => {
  try {
    // Lấy tham số từ query string (from và to là các ngày)
    const { from, to } = req.query;
    console.log('Lấy dữ liệu từ ngày:', from, 'đến ngày:', to);
    
    // Gọi service getDashboardOverview
    await statisticService.getDashboardOverview({ from, to }, (err, result) => {
      if (err) {
        console.error('Lỗi trong service:', err);
        return res.status(500).json({ message: 'Lỗi khi lấy thông tin dashboard', error: err });
      }

      // Trả kết quả dưới dạng JSON
      return res.status(200).json(result);
    });
  } catch (error) {
    console.error("Lỗi trong controller getDashboardOverview:", error);
    res.status(500).json({ message: 'Lỗi hệ thống', error });
  }
};

module.exports = {getQuantitySaleOfCategory,  getRevenueLast7Days, getDashboardOverviewController}