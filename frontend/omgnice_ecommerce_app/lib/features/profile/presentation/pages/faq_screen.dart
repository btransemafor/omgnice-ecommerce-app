import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:animate_do/animate_do.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  String _language = 'vi'; // Default language: Vietnamese

  void _toggleLanguage() {
    setState(() {
      _language = _language == 'vi' ? 'en' : 'vi';
    });
  }

   final Color accentColor = const Color(0xFF81C784); // Light Green
   final Color backgroundLightColor = const Color(0xFFF1F8E9); // Light Green Background

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth > 600 ? 20.0 : 10.0;
    final double fontSizeTitle = screenWidth > 600 ? 32.0 : 18.0;
    final double fontSizeCategory = screenWidth > 600 ? 22.0 : 16.0;
    final double fontSizeQuestion = screenWidth > 600 ? 18.0 : 14.0;

    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: BeautifulAppBar(
        title: _language == 'vi' ? 'Câu Hỏi Thường Gặp' : 'FAQs',
        gradient: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _toggleLanguage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  _language == 'vi' ? 'EN' : 'VN',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Center(
                  child: Text(
                    _language == 'vi' ? 'Tất Cả Những Gì Bạn Cần Biết' : 'Everything You Need to Know',
                    style:TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Về Đơn Hàng' : 'About Orders',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Làm sao để đặt hàng trên ứng dụng OMGNICE?'
                        : 'How do I place an order on the OMGNICE app?',
                    'answer': _language == 'vi'
                        ? 'Chọn sản phẩm yêu thích, nhấn "Thêm vào giỏ hàng" và hoàn tất thanh toán.'
                        : 'Select your favorite product, tap "Add to Cart," and complete the checkout.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Tôi có thể hủy đơn hàng như thế nào?'
                        : 'How can I cancel my order?',
                    'answer': _language == 'vi'
                        ? 'Hủy đơn trong vòng 10 phút qua mục "Đơn hàng của tôi" hoặc liên hệ CSKH.'
                        : 'Cancel within 10 minutes via "My Orders" or contact customer support.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Tôi có thể đặt hàng trước và nhận sau không?'
                        : 'Can I place an order in advance and receive it later?',
                    'answer': _language == 'vi'
                        ? 'Có, chọn thời gian giao hàng mong muốn khi thanh toán.'
                        : 'Yes, choose your preferred delivery time during checkout.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Về Vận Chuyển' : 'About Shipping',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'OMGNICE giao hàng trong bao lâu?'
                        : 'How long does OMGNICE take to deliver?',
                    'answer': _language == 'vi'
                        ? 'Thường 1–2 ngày, tùy sản phẩm và khu vực.'
                        : 'Typically 1–2 days, depending on the product and area.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Tôi có thể kiểm tra tình trạng đơn hàng ở đâu?'
                        : 'Where can I check the status of my order?',
                    'answer': _language == 'vi'
                        ? 'Theo dõi tại mục "Đơn hàng của tôi" trong ứng dụng.'
                        : 'Track it in the "My Orders" section of the app.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'OMGNICE có giao hàng ngoài giờ hành chính không?'
                        : 'Does OMGNICE deliver outside business hours?',
                    'answer': _language == 'vi'
                        ? 'Có, hỗ trợ giao buổi tối và cuối tuần ở một số khu vực.'
                        : 'Yes, evening and weekend deliveries are available in some areas.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Về Thanh Toán' : 'About Payment',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Tôi có thể thanh toán bằng những hình thức nào?'
                        : 'What payment methods are available?',
                    'answer': _language == 'vi'
                        ? 'Hỗ trợ COD, MoMo, ZaloPay, PayOS và thẻ ngân hàng.'
                        : 'Supports COD, MoMo, ZaloPay, PayOS, and bank cards.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Thanh toán có an toàn không?'
                        : 'Is payment secure?',
                    'answer': _language == 'vi'
                        ? 'Giao dịch được mã hóa, không lưu thông tin thẻ.'
                        : 'Transactions are encrypted; card info is not stored.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Về Sản Phẩm' : 'About Products',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Thức uống có phù hợp với người ăn kiêng không?'
                        : 'Are drinks suitable for diet lifestyles?',
                    'answer': _language == 'vi'
                        ? 'Có, cung cấp đồ uống ít đường, thuần chay và lành mạnh.'
                        : 'Yes, we offer low-sugar, vegan, and healthy drinks.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Có sản phẩm không đường hoặc không caffeine không?'
                        : 'Are there sugar-free or caffeine-free products?',
                    'answer': _language == 'vi'
                        ? 'Có, lọc sản phẩm theo nhu cầu khi duyệt.'
                        : 'Yes, filter products based on your needs.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Ưu Đãi & Khuyến Mãi' : 'Promotions & Offers',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Có ưu đãi cho khách hàng mới không?'
                        : 'Are there discounts for new customers?',
                    'answer': _language == 'vi'
                        ? 'Có, nhận ưu đãi khi đăng ký tài khoản lần đầu.'
                        : 'Yes, get a discount upon first-time registration.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Làm sao để sử dụng mã giảm giá?'
                        : 'How do I use a discount code?',
                    'answer': _language == 'vi'
                        ? 'Nhập mã tại thanh toán, đảm bảo mã còn hiệu lực.'
                        : 'Enter the code at checkout; ensure it’s valid.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Hỗ Trợ Khách Hàng' : 'Customer Support',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Làm sao để liên hệ CSKH?'
                        : 'How do I contact customer support?',
                    'answer': _language == 'vi'
                        ? 'Gọi hotline, gửi email hoặc chat trực tiếp trong app.'
                        : 'Call the hotline, email, or chat in the app.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Có hỗ trợ đổi trả nếu nhận sai sản phẩm không?'
                        : 'Are returns supported for wrong products?',
                    'answer': _language == 'vi'
                        ? 'Hỗ trợ đổi trả trong 3 ngày nếu sản phẩm lỗi hoặc sai.'
                        : 'Returns supported within 3 days for defective or wrong items.',
                  },
                ],
              ),
              _buildFaqCategory(
                context,
                title: _language == 'vi' ? 'Tài Khoản & Thành Viên' : 'Account & Membership',
                fontSizeCategory: fontSizeCategory,
                fontSizeQuestion: fontSizeQuestion,
                questions: [
                  {
                    'question': _language == 'vi'
                        ? 'Có cần tài khoản để đặt hàng không?'
                        : 'Do I need an account to order?',
                    'answer': _language == 'vi'
                        ? 'Có, tài khoản miễn phí giúp theo dõi đơn và ưu đãi.'
                        : 'Yes, a free account tracks orders and offers.',
                  },
                  {
                    'question': _language == 'vi'
                        ? 'Có chương trình thành viên không?'
                        : 'Is there a loyalty program?',
                    'answer': _language == 'vi'
                        ? 'Có, tích điểm mỗi đơn và đổi quà với tài khoản thành viên.'
                        : 'Yes, earn points per order and redeem rewards.',
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCategory(
    BuildContext context, {
    required String title,
    required double fontSizeCategory,
    required double fontSizeQuestion,
    required List<Map<String, String>> questions,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: fontSizeCategory,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ...questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildExpansionTile(
                        question['question']!,
                        question['answer']!,
                        fontSizeQuestion,
                        index,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
    String question,
    String answer,
    double fontSizeQuestion,
    int index,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent, // Hide default divider
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 0.0),
        childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
        iconColor: const Color(0xFF2E7D32),
        collapsedIconColor: const Color(0xFF616161),
        title: Text(
          question,
          style: TextStyle(
            fontSize: fontSizeQuestion,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        children: [
          // Custom dashed divider
          CustomDashedDivider(),
          const SizedBox(height: 8.0),
          FadeIn(
            duration: const Duration(milliseconds: 400),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: fontSizeQuestion - 2,
                color: const Color(0xFF616161),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom dashed divider widget
class CustomDashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(),
      child: Container(
        height: 1.0,
        width: double.infinity,
      ),
    );
  }
}

// Painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7D32) // Match theme color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}