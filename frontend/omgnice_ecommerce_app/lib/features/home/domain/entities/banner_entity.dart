class BannerEntity {
  final int? id; 
  final String title;            // Tiêu đề banner
  final String imageUrl;         // URL ảnh banner
  final String actionType;       // Loại hành động khi click (e.g. "LUCKY_WHEEL", "PRODUCT_DETAIL", "CATEGORY")
  final String? actionValue;     // Giá trị hành động (ví dụ: id sản phẩm, id category hoặc null nếu không cần)
  final DateTime startTime;      // Thời gian bắt đầu hiển thị banner
  final DateTime endTime;        // Thời gian kết thúc hiển thị banner
  final int? productId;          // Id sản phẩm liên quan (nếu có)
  final int? categoryId;         // Id danh mục liên quan (nếu có)
  final bool isLuckyWheelBanner; // Có phải banner vòng quay may mắn không
  final DateTime createdAt;      // Thời gian tạo banner
  final bool isActive;           // Banner còn hiệu lực (dựa trên thời gian)
  final bool isVisible;          // Banner có đang được bật hiển thị (dễ tắt bật trên server)
  final int displayOrder;        // Thứ tự ưu tiên hiển thị banner (banner nào nhỏ hơn lên trên)

  const BannerEntity({
    required this.id, 
    required this.title,
    required this.imageUrl,
    required this.actionType,
    this.actionValue,
    required this.startTime,
    required this.endTime,
    this.productId,
    this.categoryId,
    this.isLuckyWheelBanner = false,
    required this.createdAt,
    this.isVisible = true,
    this.displayOrder = 0,
    this.isActive = true 
  });

  bool get isActiveNow {
    final now = DateTime.now();
    return isVisible && now.isAfter(startTime) && now.isBefore(endTime);
  }
}
