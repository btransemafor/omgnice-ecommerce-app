import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/card_product.dart';
import 'package:provider/provider.dart';

final variants = ['S', 'M', 'L'];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _filterScaleAnimation;
  late Animation<double> _filterOpacityAnimation;

  // Filter states
  bool _isFilterVisible = false;
  RangeValues _priceRange = const RangeValues(0, 10000000);
  double _minRating = 0;
  String? _selectedCategory;
  String? _selectedSize;
  String _sortBy = 'newest';

  List<String> _categories = [];

  final List<Map<String, dynamic>> _sortOptions = [
    {'value': 'newest', 'label': 'Newest', 'icon': Icons.new_releases},
    {'value': 'price_asc', 'label': 'Price: Low to High', 'icon': Icons.trending_up},
    {'value': 'price_desc', 'label': 'Price: High to Low', 'icon': Icons.trending_down},
    {'value': 'rating', 'label': 'Highest Rated', 'icon': Icons.star},
    {'value': 'popular', 'label': 'Most Popular', 'icon': Icons.whatshot},
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      await categoryProvider.fetchCategories();

      final fetchedCategories = categoryProvider.categories;
      setState(() {
        _categories = ['All', ...fetchedCategories.map((e) => e.name).toList()];
      });

      print('Loaded categories: $_categories');
     // Provider.of<ProductProvider>(context, listen: false).resetProducts(); 
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _filterScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _filterAnimationController, curve: Curves.easeOutBack),
    );

    _filterOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _filterAnimationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });

    context.read<ProductProvider>().searchProduct();
  }

  @override
  void dispose() {
    _controller.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    HapticFeedback.lightImpact();
    _applyFilters();
  }

  void _applyFilters() {
    context.read<ProductProvider>().searchProduct(
          query: _controller.text,
          variant: _selectedSize ,
          minPrice: _priceRange.start,
          maxPrice: _priceRange.end,
          category: _selectedCategory == 'All' ? null : _selectedCategory,
          sort: _sortBy,
        );
  }

  void _toggleFilter() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });

    if (_isFilterVisible) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  void _clearFilters() {
    setState(() {
      
      _priceRange = const RangeValues(0, 10000000);
      _minRating = 0;
      _selectedCategory = null;
      _selectedSize = null;
      _sortBy = 'newest';
      _minPriceController.clear();
      _maxPriceController.clear();
    
    });
    _applyFilters();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView( // Wrap entire content in SingleChildScrollView
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Top Bar
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFF2D3436),
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3436),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          // Filter Button
                          Container(
                            decoration: BoxDecoration(
                              color: _isFilterVisible
                                  ? const Color.fromARGB(255, 12, 25, 38)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: _isFilterVisible
                                    ? Colors.white
                                    : const Color(0xFF2D3436),
                                size: 20,
                              ),
                              onPressed: _toggleFilter,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Search Bar
                      Row(
                        children: [
                          Expanded(child: _buildSearchBar()),
                          const SizedBox(width: 10),
                          _buildSortButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Panel
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: _isFilterVisible ? null : 0, // Remove fixed height
                curve: Curves.easeInOut,
                child: _isFilterVisible
                    ? FadeTransition(
                        opacity: _filterOpacityAnimation,
                        child: ScaleTransition(
                          scale: _filterScaleAnimation,
                          child: _buildFilterPanel(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Search Results
              SizedBox(
                height: MediaQuery.of(context).size.height , // Adjust height dynamically
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focusNode.hasFocus
              ? const Color(0xFF2ECC71)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: _onSearch,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3436),
        ),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(
              color: Colors.grey[500], fontWeight: FontWeight.w400, fontSize: 14),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _controller.clear();
                      _onSearch('');
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF636E72),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isEmpty) {
            _onSearch('');
          }
        },
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    final activeFilters = <Widget>[];

    if (_selectedCategory != null && _selectedCategory != 'All') {
      activeFilters.add(_buildFilterChip(_selectedCategory!, () {
        setState(() => _selectedCategory = null);
        _applyFilters();
      }));
    }

    if (_minRating > 0) {
      activeFilters.add(_buildFilterChip('${_minRating.toInt()}+ Stars', () {
        setState(() => _minRating = 0);
        _applyFilters();
      }));
    }

    if (_selectedSize != null) {
      activeFilters.add(_buildFilterChip('Size: $_selectedSize', () {
        setState(() => _selectedSize = null);
        _applyFilters();
      }));
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: activeFilters),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2ECC71)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2ECC71),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: Color(0xFF2ECC71),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        initialValue: _sortBy,
        onSelected: (value) {
          setState(() {
            _sortBy = value;
          });
          _applyFilters();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.sort_rounded,
            color: Colors.grey[600],
            size: 24,
          ),
        ),
        itemBuilder: (context) => _sortOptions.map((option) {
          return PopupMenuItem<String>(
            value: option['value'],
            child: Row(
              children: [
                Icon(
                  option['icon'],
                  size: 20,
                  color: _sortBy == option['value']
                      ? const Color(0xFF2ECC71)
                      : Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Text(
                  option['label'],
                  style: TextStyle(
                    color: _sortBy == option['value']
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFF2D3436),
                    fontWeight: _sortBy == option['value']
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Allow the panel to shrink to fit content
          children: [
            // Filter Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Active Filters
            _buildActiveFiltersChips(),

            const SizedBox(height: 16),

            // Price Range
            _buildPriceRangeSection(),

            const Divider(height: 32, thickness: 1, color: Color(0xFFEDEFF1)),

            // Categories
            _buildCategoriesSection(),

            const Divider(height: 32, thickness: 1, color: Color(0xFFEDEFF1)),

            // Rating
            _buildRatingSection(),

            const Divider(height: 32, thickness: 1, color: Color(0xFFEDEFF1)),

            // Size
            _buildSizeSection(),

            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  _toggleFilter();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${(_priceRange.start / 1000).toInt()} K',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Max: ${(_priceRange.end / 1000).toInt()} K',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000000,
          divisions: 100,
          activeColor: const Color(0xFF2ECC71),
          inactiveColor: Colors.grey[200],
          onChanged: (values) {
            setState(() {
              _priceRange = values;
              _minPriceController.text = (_priceRange.start / 1000).toInt().toString();
              _maxPriceController.text = (_priceRange.end / 1000).toInt().toString();
            });
          },
          onChangeEnd: (values) {
            _applyFilters();
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min Price',
                  labelStyle: const TextStyle(color: Color(0xFF636E72,), fontSize: 12),
                 // prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEDEFF1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double? price = double.tryParse(value.replaceAll(',', '')) ?? 0;
                    price *= 1000; // Convert K to actual price
                    setState(() {
                      _priceRange = RangeValues(
                        price!.clamp(0, _priceRange.end),
                        _priceRange.end,
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Price',
                  labelStyle: const TextStyle(color: Color(0xFF636E72), fontSize: 12),
                  //prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEDEFF1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double? price = double.tryParse(value.replaceAll(',', '')) ?? 0;
                    price *= 1000; // Convert K to actual price
                    setState(() {
                      _priceRange = RangeValues(
                        _priceRange.start,
                        price!.clamp(_priceRange.start, 10000000),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category ||
                (category == 'All' && _selectedCategory == null);

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category == 'All' ? null : category;
                });
                _applyFilters();
              },
              selectedColor: const Color(0xFF2ECC71).withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFF636E72),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
              backgroundColor: const Color(0xFFEDEFF1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                  width: 1.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(5, (index) {
            final rating = index + 1;
            final isSelected = rating <= _minRating;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _minRating = rating.toDouble();
                });
                _applyFilters();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2ECC71).withOpacity(0.15)
                      : const Color(0xFFEDEFF1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: isSelected ? const Color(0xFFFFD700) : Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating+',
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFF636E72),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: variants.map((size) {
            final isSelected = _selectedSize == size;

            return ChoiceChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedSize = isSelected ? null : size;
                });
                _applyFilters();
              },
              selectedColor: const Color(0xFF2ECC71).withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFF636E72),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
              backgroundColor: const Color(0xFFEDEFF1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                  width: 1.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

 Widget _buildContent() {
  return Consumer<ProductProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Searching...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636E72),
                ),
              ),
            ],
          ),
        );
      }

      if (provider.products.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters or search terms',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 190, left: 12, right: 12),
        child: GridView.builder(
          itemCount: provider.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return CardProduct(product: product);
          },
          physics: const BouncingScrollPhysics(), // Enable scrolling for GridView
        ),
      );
    },
  );
}
}