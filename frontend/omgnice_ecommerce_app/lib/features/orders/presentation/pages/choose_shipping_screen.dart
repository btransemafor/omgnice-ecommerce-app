import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/widget/card_shipping_method.dart';
import 'package:provider/provider.dart';

class ChooseShippingScreen extends StatefulWidget {
  const ChooseShippingScreen({super.key});

  @override
  State<ChooseShippingScreen> createState() => _ChooseShippingScreenState();
}

class _ChooseShippingScreenState extends State<ChooseShippingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      provider.getShipping();
      print('⚡ ChooseShippingScreen: Fetching shipping methods');
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: BeautifulAppBar(
        title: 'Shipping Method',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        gradient: true,
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  'Shipping Method Of OMGNICE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Icon(Icons.health_and_safety_outlined, color: Colors.green),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                if (orderProvider.isLoading) {
                  return const Center(child: CustomLoading());
                }
                if (orderProvider.listShipping.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No shipping methods available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            orderProvider.getShipping();
                            print('⚡ Retrying to fetch shipping methods');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: orderProvider.listShipping.length,
                  itemBuilder: (context, index) {
                    final item = orderProvider.listShipping[index];
                    return GestureDetector(
                      onTap: () {
                        orderProvider.ChooseShippingMethod(item);
                        print('⚡ Selected shipping method: ${item.name}');
                      },
                      child: CardShippingMethod(
                        shippingMethod: item,
                        isSelected: orderProvider.selectShipping?.id == item.id,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: orderProvider.selectShipping == null
              ? null
              : () {
                  print('⚡ Confirming shipping method: ${orderProvider.selectShipping!.name}');
                  GoRouter.of(context).pop(orderProvider.selectShipping);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }
}