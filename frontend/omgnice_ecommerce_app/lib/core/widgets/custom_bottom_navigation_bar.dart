import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final IconData fabIcon;
  final int fabIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.fabIcon,
    required this.fabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(

      height: screenHeight * 1 / 13,
      child: BottomAppBar(
        color: Colors.green.shade700,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          CircleBorder(),
        ),
        notchMargin: 8.0, // Giảm margin để FAB nổi lên hơn
       // smoothing:10,
        child: Center(
          child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            padding: EdgeInsets.only(top:7, bottom: 0),
            height: 39.0, //or whatever you want
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(icon: Icons.home, index: 0),
                _buildNavItem(icon: Icons.favorite, index: 1),
                const SizedBox(width: 65),
                _buildNavItem(icon: Icons.confirmation_num, index: 3),
                _buildNavItem(icon: Icons.person, index: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        child: Center(
          child: Icon(
            icon,
            size: 25,
            color: isSelected ? Colors.white : Colors.white60,
          ),
        ),
      ),
    );
  }
}

