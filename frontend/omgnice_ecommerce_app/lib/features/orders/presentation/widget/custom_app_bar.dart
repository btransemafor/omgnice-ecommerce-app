import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const CustomAppBar({super.key, required this.tabController});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearching = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.green,
              Colors.green.shade500,
              Colors.green.shade700,
              Colors.green.shade200,
              Colors.green.shade900,
              Colors.green.shade200,
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Back + Title + Search Icon
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: !isSearching
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: !isSearching
                                ? Center(
                                    child: Text(
                                      "My Order",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isSearching = !isSearching;
                              });
                            },
                            child: Icon(
                              isSearching ? Icons.close : Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : _buildWidgetSearch(_controller),
              ),

              // Tab Bar (luôn hiển thị)
              CustomTabBar(tabController: widget.tabController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetSearch(TextEditingController _searchController) {
    return SizedBox(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 0),
        child: Row(
          children: [
            // TextField chiếm phần còn lại
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  print('🔍 Searching: $value');
                },
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search Order Code...',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _controller.clear();
                      Provider.of<OrderProvider>(context, listen: false)
                          .setSearchKeyword('');
                    },
                  ),
                  prefixIcon:
                      const Icon(Icons.search, size: 18), // icon nhỏ lại
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Search button
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  // Thực hiện tìm kiếm
                  // Get content from search input
                  final query = _searchController.text;
                  print("${query}");
                  Provider.of<OrderProvider>(context, listen: false)
                      .setSearchKeyword(query);

                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 121, 203, 110),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 255, 255, 255)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),

                    side: const BorderSide(
                        color: Colors.green, width: 2), // Viền xanh
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 1, left: 10, right: 10, bottom: 5),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        /*  border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ), */
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TabBar(
          controller: tabController,
          isScrollable: false,
          tabs: const [
            Tab(text: "Processing"),
            Tab(text: "Completed"),
            Tab(text: "Cancel"),
          ],
          unselectedLabelColor: Colors.white.withOpacity(0.8),
          labelColor: const Color(0xFF2E7D32),
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(1),
          labelPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.fill,
        ),
      ),
    );
  }
}
