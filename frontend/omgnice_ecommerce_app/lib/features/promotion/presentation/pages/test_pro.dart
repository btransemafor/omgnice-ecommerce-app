/*
import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:provider/provider.dart';

class MyPromotionScreen extends StatefulWidget {
  const MyPromotionScreen({super.key});

  @override
  State<MyPromotionScreen> createState() => _MyPromotionScreenState();
}

class _MyPromotionScreenState extends State<MyPromotionScreen> {
@override
  void initState() {
    super.initState(); // Call the overridden method
    // Gọi fetch sau 1 frame để tránh lỗi context chưa sẵn sàng
    Future.microtask(() {
      final provider = Provider.of<PromotionProvider>(context, listen: false);
      provider.GetUserPromotion(); 
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Promotions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<PromotionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Kiểm tra xem dữ liệu đã có chưa
            final promotions = provider.userPromotions;
            if (promotions.isEmpty) {
              return const Center(child: Text("No promotions available."));
            }

            return ListView.builder(
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                final promotion = promotions[index];
                return ListTile(
                  title: Text(promotion.title ?? 'No Title'),
                  subtitle: Text(promotion.description ?? 'No Description'),
                  onTap: () {
                    // Handle promotion tap
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
*/ 
