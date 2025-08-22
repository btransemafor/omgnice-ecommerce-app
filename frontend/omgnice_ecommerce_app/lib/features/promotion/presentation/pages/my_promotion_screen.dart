// ignore_for_file: deprecated_member_use, avoid_print, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/core/widgets/dialogs.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/my_promotion_card.dart';
import 'package:provider/provider.dart';

class MyPromotionScreen extends StatefulWidget {
  const MyPromotionScreen({super.key});

  @override
  State<MyPromotionScreen> createState() => _MyPromotionScreenState();
}

class _MyPromotionScreenState extends State<MyPromotionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Future.microtask(() {
      final provider = Provider.of<PromotionProvider>(context, listen: false);
      provider.GetUserPromotion();
      _animationController.forward();
    });
    
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: BeautifulAppBar(
        title: 'My Vouchers',
        gradient: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5, right: 5),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                // border: Border.all(color: Colors.grey.shade200,),
              ),
              child: IconButton(
                  onPressed: () {
                    // Todo: Show Return Home ....
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                        contentPadding: const EdgeInsets.all(24),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home_outlined,
                                color: Colors.green[700], size: 40),
                            const SizedBox(height: 16),
                            Text(
                              'Do you want to return home ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        actionsPadding:
                            const EdgeInsets.only(bottom: 16, right: 16),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<ScreenManager>(context, listen: false)
                                  .goToHome();
                              context.goNamed('home');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Yes',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.green,
        displacement: 40, // Giúp hiệu ứng kéo mượt hơn
        strokeWidth: 2.5, // Mỏng hơn, nhẹ nhàng hơn
        onRefresh: () async {
           await Future.wait([
               Provider.of<PromotionProvider>(context, listen: false)
            .GetUserPromotion()
           ]); 
           
        }, 
      
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterSection(context),
              Expanded(
                child: Consumer<PromotionProvider>(
                  builder: (context, promotionProvider, child) {
                    if (promotionProvider.isLoading) {
                      return const Center(child: CustomLoading());
                    }
                    final filteredPromotions = promotionProvider
                        .filterPromotions(promotionProvider.filterStatus);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        key: ValueKey(filteredPromotions.length),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Semantics(
                              label: 'Number of vouchers',
                              child: Text(
                                '${filteredPromotions.length} Vouchers',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildPromotionsList(filteredPromotions),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomMyPromotion(context),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Semantics(
            label: 'Filter label',
            child: Text(
              'Filter: ',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Expiring Soon'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final provider = Provider.of<PromotionProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = provider.filterStatus == label;

    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: ActionChip(
        label: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        backgroundColor: isSelected ? Colors.green : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isSelected ? Colors.green : Colors.grey.shade300),
        ),
        onPressed: () {
          provider.setFilter(label);
          _animationController.forward(from: 0);
        },
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  Widget _buildPromotionsList(List<PromotionEntity> filteredPromotions) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Add PromoCodeField at the top of the list
        PromoCodeField(orderTotal: 100000),
        if (filteredPromotions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 50,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Consumer<PromotionProvider>(
                    builder: (context, provider, _) {
                      return Text(
                        provider.filterStatus == 'All'
                            ? 'No vouchers available'
                            : 'No vouchers expiring soon',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      context.pushNamed('promotion');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'Discover More',
                      style: GoogleFonts.inter(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredPromotions.length,
                  itemBuilder: (context, index) {
                    final promotion = filteredPromotions[index];
                    final isSelected =
                        cartProvider.selectedPromotion?.id == promotion.id;
                    return PromotionCard(
                      promotion: promotion,
                      isSelected: isSelected,
                      onTap: () {
                        cartProvider.selectPromotion(promotion);
                        print('Selected promotion: ${promotion.code}');
                      },
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBottomMyPromotion(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: screenHeight * 0.095,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
                colorScheme.brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.grey.shade50,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cartProvider.selectedPromotion != null
                      ? () async {
                          final oldSelected = cartProvider.selectedPromotion;
                          if (oldSelected != null) {
                            await cartProvider.applyPromotion(oldSelected);
                          }
                          final success = cartProvider.isApplySuccess;
                          final code = oldSelected?.code;
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Dialogs.showVoucherStatusDialog(
                                context, success, code!);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cartProvider.selectedPromotion != null
                        ? Colors.green
                        : colorScheme.onSurface.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Apply Voucher',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  context.pushNamed('promotion');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green, width: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Discover More',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PromoCodeField extends StatefulWidget {
  final double orderTotal;
  const PromoCodeField({Key? key, required this.orderTotal}) : super(key: key);

  @override
  _PromoCodeFieldState createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<PromoCodeField> {
  final TextEditingController _controller = TextEditingController();
  bool _isApplying = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyPromoCode() async {
    final promoCode = _controller.text.trim();
    if (promoCode.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please Enter Promotion Before Applying',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 88, 86, 94),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    print("🎯 Bắt đầu apply promotion: $promoCode");

    // Chỉ update UI nếu widget còn mounted
    if (mounted) {
      setState(() {
        _isApplying = true;
      });
    }

    try {
      // Lấy provider - những operations này KHÔNG cần mounted
      final promotionProvider =
          Provider.of<PromotionProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      print("🔍 Searching promotion...");

      // TIẾP TUC search promotion dù widget có bị unmount
      final searchedPromotion =
          await promotionProvider.SearchPromotion(promoCode);

      print("📋 Search completed. Widget mounted: $mounted");

      if (searchedPromotion != null) {
        print("✅ Found promotion: ${searchedPromotion.code}");

        // TIẾP TUC apply promotion - không cần widget mounted
        print("🚀 Applying promotion (background)...");
        cartProvider.selectPromotion(searchedPromotion);
        await cartProvider.applyPromotion(searchedPromotion);

        print(
            "🎉 Promotion applied successfully: ${cartProvider.isApplySuccess}");

        // CHỈ update UI nếu widget vẫn còn mounted
        if (mounted) {
          print("📱 Widget still mounted - updating UI");
          setState(() {
            if (_controller.text.trim().toLowerCase() !=
                searchedPromotion.code?.toLowerCase()) {
              _controller.text = searchedPromotion?.code as String;
            }
          });

          if (cartProvider.isApplySuccess) {
            _showSuccessMessage(promoCode);
          } else {
            _showErrorMessage('Không thể áp dụng mã $promoCode');
            cartProvider.resetSelectPromotion();
          }
        } else {
          // Widget đã unmount nhưng promotion vẫn được apply
          print("📱 Widget unmounted - but promotion applied in background");
          print("💾 Promotion data saved in CartProvider");

          // Có thể lưu notification để hiện khi user quay lại
          if (cartProvider.isApplySuccess) {
            //  _saveSuccessNotification(promoCode);
          } else {
            // _saveErrorNotification('Không thể áp dụng mã $promoCode');
          }
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Not found"),
          backgroundColor: Colors.red,
        ),
      );
        print("❌ Promotion not found: $promoCode");

        if (mounted) {
          _showErrorMessage('Không tìm thấy mã khuyến mãi: $promoCode');
        } else {
          // _saveErrorNotification('Không tìm thấy mã khuyến mãi: $promoCode');
        }
      }
    } catch (e) {
      print("💥 Error applying promo code: $e");
      _showErrorMessage('Voucher code not found!');

      if (mounted) {
        _showErrorMessage('Có lỗi xảy ra: ${e.toString()}');
      } else {
        // _saveErrorNotification('Có lỗi xảy ra: ${e.toString()}');
      }
    } finally {
      // CHỈ update loading state nếu widget còn mounted
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
        print("🔄 UI loading state reset");
      } else {
        print("🔄 Operation completed in background");
      }
    }
  }

  void _showSuccessMessage(String promoCode) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Áp dụng mã $promoCode thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showErrorMessage(String message) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

  }

  void _clearPromotion() {
    if (mounted) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.resetSelectPromotion();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer2<PromotionProvider, CartProvider>(
      builder: (context, promotionProvider, cartProvider, child) {
        final hasAppliedPromotion = cartProvider.selectedPromotion != null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.poppins(),
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        labelText: !hasAppliedPromotion
                            ? 'Enter Voucher Code'
                            : cartProvider.selectedPromotion!.code,
                        labelStyle: GoogleFonts.poppins(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.green.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2),
                        ),
                        suffixIcon: hasAppliedPromotion
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                      ),
                      enabled: !hasAppliedPromotion && !_isApplying,
                      onSubmitted: (_) => _applyPromoCode(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _applyPromoCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasAppliedPromotion ? Colors.grey : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: _isApplying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            hasAppliedPromotion ? 'Choosing' : 'Apply',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Hiển thị thông tin promotion đã áp dụng
              if (hasAppliedPromotion && cartProvider.selectedPromotion != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã: ${cartProvider.selectedPromotion!.code}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cartProvider.selectedPromotion!.description ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _clearPromotion,
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 20),
                        tooltip: 'Bỏ áp dụng',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
