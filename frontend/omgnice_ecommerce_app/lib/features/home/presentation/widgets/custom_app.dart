import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:omgnice_ecommerce_app/features/auth/presentation/provider/user_provider.dart';
import 'package:omgnice_ecommerce_app/features/home/presentation/widgets/notification_bell.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/screens/notifications_page.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/widgets/animated_search_bar.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActions;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final Widget? leadingWidget;
  final List<Widget>? actionWidgets;
  final Widget? titleWidget;
  final Function? onBackPressed;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.showBackButton = true,
    this.showActions = true,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.height = kToolbarHeight + 30,
    this.leadingWidget,
    this.actionWidgets,
    this.titleWidget,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _determineBrightness(backgroundColor),
      ),
    );

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.9),
            backgroundColor.withOpacity(0.85),
            backgroundColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildAppBarContent(context),
        ),
      ),
    );
  }

  Widget _buildAppBarContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Leading widget (back button or custom widget)
        if (showBackButton)
          leadingWidget ??
              GestureDetector(
                onTap: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: textColor,
                    size: 18,
                  ),
                ),
              ),
        if (!showBackButton && leadingWidget != null) leadingWidget!,
        if (!showBackButton && leadingWidget == null) const SizedBox(width: 40),

        // Title
        Expanded(
          child: titleWidget ??
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
        ),

        // Action widgets
        if (showActions && actionWidgets != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actionWidgets!,
          )
        else if (showActions)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(Icons.search, () {
                // Add search functionality
              }),
              const SizedBox(width: 16),
              _buildActionButton(Icons.notifications_none_outlined, () {
                // Add notification functionality
              }),
            ],
          )
        else
          const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: textColor,
          size: 18,
        ),
      ),
    );
  }

  Brightness _determineBrightness(Color color) {
    // Calculate the perceived brightness of the background color
    final double brightness =
        (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;
    return brightness > 128 ? Brightness.dark : Brightness.light;
  }
}

// Example of a custom search app bar
class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String)? onSearchChanged;
  final Function()? onBackPressed;
  final Color backgroundColor;
  final String hintText;

  const CustomSearchAppBar({
    Key? key,
    required this.searchController,
    this.onSearchChanged,
    this.onBackPressed,
    this.backgroundColor = Colors.green,
    this.hintText = 'Search products...',
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.9),
            backgroundColor.withOpacity(0.85),
            backgroundColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                searchController.clear();
                                if (onSearchChanged != null) {
                                  onSearchChanged!('');
                                }
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onSearchTap;
  final Function()? onNotificationTap;
  final Function()? onCartTap;
  final int cartItemCount;
  final bool isPinned;

  const HomeAppBar({
    Key? key,
    this.onSearchTap,
    this.onNotificationTap,
    this.onCartTap,
    this.cartItemCount = 0,
    this.isPinned = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 132, 202, 132),
            const Color(0xFF96e6a1),
            const Color.fromARGB(255, 5, 122, 28),
            const Color.fromARGB(255, 5, 122, 28),
            const Color.fromARGB(255, 3, 38, 8),
            const Color.fromARGB(255, 5, 122, 28),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo User:
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final avatarUrl = userProvider.userInfo?.avatar ??
                          'https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png';
                      return GestureDetector(
                        onTap: () {
                          (context).pushNamed('profile');
                        } ,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(avatarUrl),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      );
                    },
                  ),

                  Text(
                    'OMGNICE',
                    style: GoogleFonts.poppins(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Updated notification bell with animation
                  NotificationBellWidget(
                    onTap: onNotificationTap ?? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage()
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),

              AnimatedSearchBar(),

              const SizedBox(height: 12),

              // Phần lời chào với hiệu ứng nổi bật
              Stack(
                children: [
                  // Drop shadow cho text
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Lottie.asset(
                              'assets/lottie/hand_waving.json',
                              width: 35,
                              height: 35,
                              fit: BoxFit.contain,
                            ),
                            Consumer<UserProvider>(
                              builder: (context, userProv, child) {
                                return Text(
                                  'Hi, ${userProv.userInfo?.name ?? 'Baby'}',
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(1, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // Slogan với hiệu ứng nổi bật
                        Text(
                          "Don't hesitate, just buy it now!",
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(0.5, 0.5),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildActionButton(
    IconData icon, Function()? onTap, BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(children: [
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
      Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
              '${Provider.of<NotificationProvider>(context, listen: false).notifications.length}')),

      //
    ]),
  );
}

// Phương pháp thay thế - Phong cách thú vị hơn
Widget _buildWelcomeText(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Phần lời chào
      Row(
        children: [
          Lottie.asset(
            'assets/lottie/hand_waving.json',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          Consumer<UserProvider>(
            builder: (context, userProv, child) {
              return ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.yellow.shade100,
                      Colors.white,
                    ],
                    stops: const [0.1, 0.5, 0.9],
                  ).createShader(bounds);
                },
                child: Text(
                  'Hi, ${userProv.userInfo?.name ?? 'Baby'}',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      const SizedBox(height: 8),

      // Slogan với hiệu ứng animation
      TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 1),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade500],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đừng có sợ nha, mua liền đi',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}

// Widget để tạo hiệu ứng animation cho text
class TypewriterAnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const TypewriterAnimatedText({
    Key? key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<TypewriterAnimatedText> createState() => _TypewriterAnimatedTextState();
}

class _TypewriterAnimatedTextState extends State<TypewriterAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _animation.value),
      style: widget.style,
    );
  }
}

// Usage example:
class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        showBackButton: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text('Your content here'),
      ),
    );
  }
}

// Ví dụ sử dụng HomeAppBar thông thường (có pinned)
class NormalHomePage extends StatelessWidget {
  const NormalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        isPinned: true, // mặc định là true nên có thể bỏ qua
        cartItemCount: 3,
        onSearchTap: () {
          // Navigate to search screen
        },
        onNotificationTap: () {
          // Navigate to notifications screen
        },
        onCartTap: () {
          // Navigate to cart screen
        },
      ),
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

// Usage example with Home AppBar:
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng với SliverAppBar khi bạn muốn tắt pinned
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false, // Có thể tắt pinned ở đây
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              background: HomeAppBar(
                isPinned: false,
                cartItemCount: 3,
                onSearchTap: () {
                  // Navigate to search screen
                },
                onNotificationTap: () {
                  // Navigate to notifications screen
                },
                onCartTap: () {
                  // Navigate to cart screen
                },
              ),
            ),
            expandedHeight: kToolbarHeight + 30,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Content here
              Container(
                height: 800,
                child: Center(
                  child: Text('Home Page Content'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// Usage example with Search AppBar:
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchAppBar(
        searchController: _searchController,
        onSearchChanged: (value) {
          // Handle search
          print('Searching for: $value');
        },
      ),
      body: Center(
        child: Text('Search Results'),
      ),
    );
  }
}
