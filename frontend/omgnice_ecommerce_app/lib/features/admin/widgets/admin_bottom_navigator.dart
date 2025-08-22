import 'package:flutter/material.dart';

class AdminBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelectedItem;

  const AdminBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onSelectedItem,
  });

  @override
  Widget build(BuildContext context) {
    // Gious Topa color scheme
    const primaryColor =
        Color.fromARGB(255, 16, 160, 23); // Deep purple for primary
    const secondaryColor = Color(0xFFFFA726); // Orange accent
    const backgroundColor = Color(0xFFF9F9FB); // Light background
    const inactiveColor = Color(0xFF9E9E9E); // Gray for inactive items

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              index: 0,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
              accentColor: secondaryColor,
            ),
            _buildNavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Orders',
              index: 1,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
              accentColor: secondaryColor,
            ),
            /*  _buildFloatingNavButton(
              context: context,
              primaryColor: primaryColor,
              secondaryColor: const Color.fromARGB(255, 21, 137, 66),
            ), */

            _buildNavItem(
              icon: Icons.person_2_outlined,
              label: 'Users',
              index: 2,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
              accentColor: secondaryColor,
            ),
            _buildNavItem(
              icon: Icons.shopping_bag_rounded,
              label: 'Products',
              index: 3,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
              accentColor: secondaryColor,
            ),
            _buildNavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              index: 4,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
              accentColor: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryColor,
    required Color inactiveColor,
    required Color accentColor,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onSelectedItem(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : inactiveColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavButton({
    required BuildContext context,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return GestureDetector(
      onTap: () {
        // Show action dialog or open a specific screen
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              _buildQuickActionMenu(context, primaryColor, secondaryColor),
        );
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, secondaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildQuickActionMenu(
      BuildContext context, Color primaryColor, Color secondaryColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.add_shopping_cart,
                label: 'Add Product',
                color: primaryColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildActionButton(
                icon: Icons.card_giftcard,
                label: 'New Gift',
                color: secondaryColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildActionButton(
                icon: Icons.list_alt,
                label: 'Orders',
                color: Colors.green,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
