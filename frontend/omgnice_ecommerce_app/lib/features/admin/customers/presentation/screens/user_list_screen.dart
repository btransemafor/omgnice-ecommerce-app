import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/admin/customers/presentation/widgets/user_card.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchAllUsers();
    });
  Provider.of<UserProvider>(context, listen: false)
          .getProfileUser();


  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // Filter users based on search query and status
  List<UserEntity> _filteredUsers(List<UserEntity> users) {
    List<UserEntity> filtered = List.from(users);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        final nameMatch = user.name?.toLowerCase().contains(query) ?? false;
        final phoneMatch = user.phone?.contains(query) ?? false;
        return nameMatch || phoneMatch;
      }).toList();
    }

    // Filter by status - Sửa lỗi logic ở đây
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((user) {
            // Kiểm tra cả isActive và active properties
            final userStatus = user.isActive ?? user.active ?? true;
            return userStatus == (_selectedFilter == 'active');
          })
          .toList();
    }

    return filtered;
  }

  // Toggle user status (active/blocked) - Cải thiện function này
  Future<void> _toggleUserStatus(String userId, bool currentStatus) async {
    if (userId.isEmpty) {
      _showSnackBar('Error: Invalid user ID', Colors.red);
      return;
    }
    
    final newStatus = !currentStatus;
    
    try {
      // Hiển thị loading state ngay lập tức
      setState(() {
        // Tạm thời cập nhật UI local trước
      });
      
      await Provider.of<UserProvider>(context, listen: false)
          .updateUserInfo({'is_active': newStatus.toString()}, userId);
      
      // Force refresh user list sau khi update
      await Provider.of<UserProvider>(context, listen: false).fetchAllUsers();
      
      _showSnackBar(
        'Successfully ${newStatus ? 'activated' : 'locked'} account',
        Colors.green,
      );
    } catch (e) {
      _showSnackBar('Error updating status: $e', Colors.red);
      // Revert local changes if error occurs
      setState(() {});
    }
  }

  // Call user
  void _callUser(String? phone) {
    if (phone == null || phone.isEmpty) {
      _showSnackBar('Error: Phone number not available', Colors.red);
      return;
    }
    _showSnackBar('Calling $phone...', Colors.blue);
  }

  // Message user
  void _messageUser(String? phone) {
    if (phone == null || phone.isEmpty) {
      _showSnackBar('Error: Phone number not available', Colors.red);
      return;
    }
    _showSnackBar('Composing message to $phone...', Colors.blue);
  }

  // Show SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.inter(fontSize: 13)),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // Handle pull-to-refresh
  Future<void> _onRefresh() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchAllUsers();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      _showSnackBar('Error refreshing user list: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'User Management',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CustomLoading());
          }

          if (userProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.errorMessage,
                    style:
                        theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userProvider.fetchAllUsers(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          final users = userProvider.users;
          final filteredUsers = _filteredUsers(users);
          
          // Cải thiện cách tính toán stats
          final totalUsers = users.length;
          final activeUsers = users.where((u) => 
            (u.isActive ?? u.active ?? true) == true
          ).length;
          final blockedUsers = users.where((u) => 
            (u.isActive ?? u.active ?? true) == false
          ).length;

          return Column(
            children: [
              // Search and Filter Section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2C2C2E)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search by name or phone number...',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            value: 'all',
                            selectedValue: _selectedFilter,
                            onSelected: (value) =>
                                setState(() => _selectedFilter = value),
                            count: totalUsers,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Active',
                            value: 'active',
                            selectedValue: _selectedFilter,
                            onSelected: (value) =>
                                setState(() => _selectedFilter = value),
                            count: activeUsers,
                            color: const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Blocked',
                            value: 'blocked',
                            selectedValue: _selectedFilter,
                            onSelected: (value) =>
                                setState(() => _selectedFilter = value),
                            count: blockedUsers,
                            color: const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Stats Summary
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.1),
                      const Color(0xFF8B5CF6).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.people_outline,
                        label: 'Total Users',
                        value: totalUsers.toString(),
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.2)),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_outline,
                        label: 'Active',
                        value: activeUsers.toString(),
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.2)),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.block,
                        label: 'Blocked',
                        value: blockedUsers.toString(),
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              // User List with Refresh
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  header: const WaterDropHeader(
                    waterDropColor: Colors.green,
                    complete: Icon(Icons.check, color: Colors.green),
                  ),
                  child: filteredUsers.isEmpty
                      ? _EmptyState(searchQuery: _searchQuery)
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            // Sửa lỗi logic status ở đây
                            final userStatus = user.isActive ?? user.active ?? true;
                            
                            return PremiumUserCard(
                              key: ValueKey(user.id), // Thêm key để Flutter track changes
                              onTap: () {
                                if (user.id != null) {
                                  context.pushNamed('userDetail',
                                      extra: {'userId': user.id});
                                } else {
                                  _showSnackBar(
                                      'Error: Invalid user ID', Colors.red);
                                }
                              },
                              id: user.id ?? '',
                              rank: 'NewBie',
                              name: user.name ?? 'N/A',
                              phone: user.phone ?? 'N/A',
                              avatarUrl: user.avatar ?? '',
                              totalOrders:
                                  user.userstats?.totalQuantityOrder ?? 0,
                              totalSpending:
                                  (user.userstats?.totalSpending ?? 0.0)
                                      .toInt(),
                              points: user.point ?? 0,
                              status: userStatus ? 'active' : 'locked',
                              lastOrderDate: user.userstats?.lastOrderDate
                                      is DateTime
                                  ? user.userstats!.lastOrderDate as DateTime
                                  : DateTime.now(),
                              onToggleStatus: () => _toggleUserStatus(
                                  user.id ?? '', userStatus),
                              onCall: () => _callUser(user.phone),
                              onMessage: () => _messageUser(user.phone),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Filter Chip Widget - Không thay đổi
class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Function(String) onSelected;
  final int count;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    final chipColor = color ?? const Color(0xFF6366F1);

    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: chipColor.withOpacity(isSelected ? 1.0 : 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : chipColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : chipColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : chipColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stat Item Widget - Không thay đổi
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: color),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Empty State Widget - Không thay đổi
class _EmptyState extends StatelessWidget {
  final String searchQuery;

  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 30,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isEmpty ? 'No users found' : 'No search results',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Add new users to get started'
                : 'Try searching with different keywords',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}