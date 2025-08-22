import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/features/cart/domain/models/cart_item_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatefulWidget {
  final CartItemViewModel cartItem;

  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  bool isExpand = false;
  String _selectedSize = 'M';
  double _selectedPrice = 0;
  int? _selectedVariantId;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false; // Debounce cho quantity

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _selectedSize = widget.cartItem.cartItemModel.variantName ?? 'M';
    _selectedPrice = widget.cartItem.cartItemModel.discountPrice?.toDouble() ?? 0.0;
    _selectedVariantId = widget.cartItem.cartItemModel.variantId;
  }

  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItem.cartItemModel != widget.cartItem.cartItemModel) {
      setState(() {
        _selectedSize = widget.cartItem.cartItemModel.variantName ?? 'M';
        _selectedPrice = widget.cartItem.cartItemModel.discountPrice?.toDouble() ?? 0;
        _selectedVariantId = widget.cartItem.cartItemModel.variantId;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> showModalBox(
      BuildContext context, String notePrevious, int cartItemId) async {
    TextEditingController _controller =
        TextEditingController(text: notePrevious);

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Enter Your Note Order',
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newNote = _controller.text;
                if (newNote.isNotEmpty) {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  bool success = await cartProvider.updateCartItem(
                    {"note": newNote},
                    cartItemId,
                  );
                  if (success) {
                    cartProvider.editNote(cartItemId, newNote);
                    Navigator.of(context).pop(newNote);
                  } else {
                    Navigator.of(context).pop(null);
                  }
                } else {
                  Navigator.of(context).pop(null);
                }
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSizeDropdown(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final variants = await cartProvider
        .getVariantsByProductId(widget.cartItem.cartItemModel.productId!);

    if (variants.isEmpty) {
      ErrorHelper.showError(context, "Không có biến thể nào cho sản phẩm này.");
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Choose Size',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              ...variants.map((variant) => ListTile(
                    title: Text(
                      variant['variant_name'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: _selectedSize == variant['variant_name']
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedSize == variant['variant_name']
                            ? Colors.green.shade500
                            : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      '${variant['discount_price']} đ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () async {
                      final cartItemId =
                          widget.cartItem.cartItemModel.cartItemId!;
                      bool success = await cartProvider.updateCartItem(
                        {
                          "variantId": variant['variant_id'],
                          "variantName": variant['variant_name'],
                          "discountPrice": variant['discount_price'],
                        },
                        cartItemId,
                      );
                      if (success) {
                        setState(() {
                          _selectedSize = variant['variant_name'];
                       _selectedPrice = double.tryParse(variant['discount_price'].toString()) ?? 0.0;
                          _selectedVariantId = variant['variant_id'];
                        });
                        cartProvider.updateCartItemLocally(
                          cartItemId,
                          variant['variant_name'],
                          double.parse(variant['discount_price'].toString()),
                          variant['variant_id'],
                        );
                        Navigator.maybePop(context);
                      } else {
                        ErrorHelper.showError(
                            context, "Cập nhật kích thước thất bại.");
                      }
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (context) async {
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              final cartItemId = widget.cartItem.cartItemModel.cartItemId;
              if (cartItemId != null) {
                await cartProvider.deleteItem(cartItemId);
                if (context.mounted) {
                  SuccessHelper.showSuccess(
                      context, "Xóa sản phẩm thành công!");
                }
              } else {
                ErrorHelper.showError(context, "Xóa sản phẩm thất bại!");
              }
            },
            backgroundColor: Colors.white,
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.delete,
                size: 50,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: size.height * 0.16,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.cartItem.cartItemModel.imageProduct ??
                          'https://via.placeholder.com/150',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Information
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product Name
                      Flexible(
                        child: Text(
                          widget.cartItem.cartItemModel.nameProduct ?? '',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.035,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Size and Dropdown
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Size:',
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.green.withOpacity(0.3),
                            onTap: () async {
                              if (!_isProcessing) {
                                _controller.forward();
                                _showSizeDropdown(context);
                                _controller.reverse();
                              }
                            },
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedSize,
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.032,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: size.width * 0.045,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Price
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF82E62B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Text(
                          '$_selectedPrice đ',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Quantity and Expand Note
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildAddToCartContainer(
                        () async {
                          if (!_isProcessing) {
                            setState(() => _isProcessing = true);
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProvider.decreaseQuantity(
                                widget.cartItem.cartItemModel.cartItemId!);
                            setState(() => _isProcessing = false);
                          }
                        },
                        () async {
                          if (!_isProcessing) {
                            setState(() => _isProcessing = true);
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProvider.increaseQuantity(
                                widget.cartItem.cartItemModel.cartItemId!);
                            setState(() => _isProcessing = false);
                          }
                        },
                        Text(
                          widget.cartItem.cartItemModel.quantity.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpand = !isExpand;
                          });
                        },
                        child: Icon(
                          isExpand
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.green,
                          size: size.width * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            crossFadeState:
                isExpand ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF82E62B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit note',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.cartItem.cartItemModel.note ?? 'No note',
                          style:
                              GoogleFonts.poppins(fontSize: size.width * 0.032),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () async {
                          final newNote = await showModalBox(
                            context,
                            widget.cartItem.cartItemModel.note ?? '',
                            widget.cartItem.cartItemModel.cartItemId!,
                          );
                          if (newNote != null) {
                            setState(() {});
                          }
                        },
                        child: SizedBox(
                            height: 20,
                            child: Image.asset('assets/icon-edit.jpg'))),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget buildAddToCartContainer(
      VoidCallback onRemove, VoidCallback onAdd, Widget displayWidget) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildQuantityButton(
              Icons.remove, false, _isProcessing ? null : onRemove),
          displayWidget,
          buildQuantityButton(Icons.add, true, _isProcessing ? null : onAdd),
        ],
      ),
    );
  }

  Widget buildQuantityButton(
      IconData icon, bool isAdd, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isAdd ? const Color(0xFF50CD1D) : Colors.transparent,
          border: isAdd
              ? null
              : Border.all(width: 1, color: const Color(0xFF50CD1D)),
        ),
        child: Icon(
          icon,
          color: isAdd ? Colors.white : const Color(0xFF50CD1D),
          size: 18,
        ),
      ),
    );
  }
}