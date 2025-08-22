import 'package:flutter/material.dart';

class TransactionSuccessPage extends StatelessWidget {
  const TransactionSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors used in the design
    const Color greenColor = Color(0xFF2E7D32);
    const Color greenLight = Color(0xFFE8F5E9);
    const Color darkTextColor = Color(0xFF1B3B1B);
    const Color greyTextColor = Color(0xFF7A7A7A);

    return Scaffold(
      body: Stack(
        children: [
          // Background image placeholder - replace with actual pattern image asset or network image
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://i.imgur.com/3Xq6Q0M.png', // Placeholder pattern image URL, replace with actual
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top bar with logo and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'VCB',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            TextSpan(
                              text: 'Digibank',
                              style: TextStyle(
                                color: Color(0xFF7CB342),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.mail_outline,
                          color: Color(0xFF2E7D32),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Success circle with check icon and ring shadow
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF2E7D32),
                          Color(0xFF2E7D32),
                        ],
                        center: Alignment.center,
                        radius: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Success text
                  const Text(
                    'Giao dịch thành công!',
                    style: TextStyle(
                      color: Color(0xFF1B3B1B),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Amount text
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '16,000 ',
                          style: TextStyle(
                            color: Color(0xFF1B3B1B),
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: 'VND',
                          style: TextStyle(
                            color: Color(0xFF1B3B1B),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Timestamp
                  const Text(
                    '18:46 Thứ Năm 19/06/2025',
                    style: TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Transaction details card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            label: 'Tài khoản/thẻ nhận',
                            value: 'VQRQ000043h1g',
                            isBoldValue: true,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            label: 'Tên người nhận',
                            value: 'NGUYEN THI NGOC DUNG',
                            isBoldValue: true,
                            maxLines: 2,
                          ),
                          _buildDivider(),
                          _buildDetailRowWithImage(
                            label: 'Ngân hàng nhận',
                            value: 'MB',
                            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/MB_Bank_logo.svg/1200px-MB_Bank_logo.svg.png',
                            subValue: 'Ngân hàng Quân Đội',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            label: 'Nội dung',
                            value: 'Thanh toan QR',
                            isBoldValue: true,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            label: 'Phí chuyển tiền',
                            value: 'Miễn phí',
                            isBoldValue: true,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            label: 'Hình thức chuyển',
                            value: 'Chuyển tiền nhanh 24/7',
                            isBoldValue: true,
                            maxLines: 2,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            label: 'Mã giao dịch',
                            value: '9911634693',
                            isBoldValue: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isBoldValue = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A7A7A),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithImage({
    required String label,
    required String value,
    required String imageUrl,
    String? subValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Image.network(
                      imageUrl,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subValue != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                subValue,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFEEEEEE),
      thickness: 1,
      height: 24,
    );
  }
}
