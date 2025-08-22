import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:app_links/app_links.dart';

class PayOSWebViewPage extends StatefulWidget {
  final String checkoutUrl;
  final String orderId;
  final String orderCode; 
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onExit;

  const PayOSWebViewPage({
    super.key,
    required this.checkoutUrl,
    required this.orderCode,
    required this.orderId,
    this.onSuccess,
    this.onCancel,
    this.onExit,
  });

  @override
  State<PayOSWebViewPage> createState() => _PayOSWebViewPageState();
}

class _PayOSWebViewPageState extends State<PayOSWebViewPage>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasHandledResult = false;
  late Timer? _loadingTimer;
  late Timer? _pollingTimer;
  late AnimationController _animationController;
  late Animation<double> _loadingAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _deepLinkSubscription;
  bool _paymentStatus = false;
  int _lastApiCallTime = 0;
  int _apiCallCount = 0;
  
  // thời gian xử lý
  final int _maxApiCalls = 50; 
  final int _pollingInterval = 3000; 
  final int _maxTimeoutMinutes = 15; 
  final int _apiTimeoutSeconds = 10; 

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    debugPrint('OrderID received in PayOSWebViewPage: ${widget.orderCode}');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), 
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    )..addListener(() {
        if (_isLoading) {
          setState(() {});
        } else {
          _animationController.stop();
          setState(() {
            _loadingAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
              CurvedAnimation(parent: _animationController, curve: Curves.linear),
            );
          });
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _loadingTimer = Timer(Duration(minutes: _maxTimeoutMinutes), () {
      if (_isLoading) {
        _handlePaymentResult('timeout', {});
      }
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0A23))
      ..setUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _isLoading = true);
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                });
                debugPrint('Page finished loading: $url');
                _injectCustomStyles();
                _startPolling();
              });
            }
          },
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            debugPrint('Navigating to: ${request.url}');

            if (request.url.contains('payos.vn') || request.url == widget.checkoutUrl) {
              return NavigationDecision.navigate;
            }

            if (request.url.contains('return') || request.url.contains('callback')) {
              if (!_hasHandledResult) {
                final status = uri.queryParameters['status'] ?? '';
                if (status.toUpperCase() == 'PAID' || status.toUpperCase() == 'SUCCESS') {
                  _handlePaymentResult('success', {});
                } else if (status.toUpperCase() == 'CANCEL' || status.toUpperCase() == 'FAILED') {
                  _handlePaymentResult('cancel', {});
                }
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    _initDeepLinks();
  }

  void _injectCustomStyles() {
    _controller.runJavaScript('''
      var style = document.createElement('style');
      style.innerHTML = `
        body { background: #0A0A23; color: #E0E0FF; }
        .payment-header { background: linear-gradient(135deg, #6E56CF, #A855F7); border-radius: 16px; }
        .btn-primary { background: linear-gradient(135deg, #6E56CF, #A855F7); border-radius: 12px; }
        input, select { background: rgba(255, 255, 255, 0.05); border-radius: 12px; }
        .card { background: #1E1E3F; border-radius: 20px; }
      `;
      document.head.appendChild(style);
    ''');
  }

  void _startPolling() {
    debugPrint('Starting payment status polling - Max calls: $_maxApiCalls, Interval: ${_pollingInterval}ms');
    
    _pollingTimer = Timer.periodic(Duration(milliseconds: _pollingInterval), (timer) async {
      if (!_hasHandledResult && _apiCallCount < _maxApiCalls) {
        final success = await _checkPaymentStatus();
        if (success) {
          debugPrint('Payment successful after ${_apiCallCount} API calls');
          _handlePaymentResult('success', {});
          timer.cancel();
        }
      } else if (_apiCallCount >= _maxApiCalls) {
        debugPrint('Reached maximum API calls ($_maxApiCalls), timing out');
        _handlePaymentResult('timeout', {});
        timer.cancel();
      }
    });
  }

  void _initDeepLinks() {
    final appLinks = AppLinks();
    _deepLinkSubscription = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && !_hasHandledResult) {
        debugPrint('Received deep link: $uri');
        if (uri.path.contains('callback') || uri.host.contains('payment')) {
          final status = uri.queryParameters['status'] ?? '';
          final orderCode = uri.queryParameters['orderCode'] ?? '';
          if (orderCode == widget.orderCode) {
            if (status.toUpperCase() == 'SUCCESS' || status.toUpperCase() == 'PAID') {
              _handlePaymentResult('success', {});
            } else if (status.toUpperCase() == 'CANCEL' || status.toUpperCase() == 'FAILED') {
              _handlePaymentResult('cancel', {});
            }
          }
        }
      }
    }, onError: (error) {
      debugPrint('Deep link error: $error');
    });

    _checkInitialDeepLink(appLinks);
  }

  Future<void> _checkInitialDeepLink(AppLinks appLinks) async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null && !_hasHandledResult) {
        debugPrint('Initial deep link: $initialUri');
        if (initialUri.path.contains('callback') || initialUri.host.contains('payment')) {
          final status = initialUri.queryParameters['status'] ?? '';
          final orderCode = initialUri.queryParameters['orderCode'] ?? '';
          if (orderCode == widget.orderCode) {
            if (status.toUpperCase() == 'SUCCESS' || status.toUpperCase() == 'PAID') {
              _handlePaymentResult('success', {});
            } else if (status.toUpperCase() == 'CANCEL' || status.toUpperCase() == 'FAILED') {
              _handlePaymentResult('cancel', {});
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking initial deep link: $e');
    }
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _pollingTimer?.cancel();
    _deepLinkSubscription?.cancel();
    _animationController.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    super.dispose();
  }

  Future<bool> _checkPaymentStatus() async {
    if (widget.orderCode.isEmpty) {
      debugPrint('Error: orderId is empty, cannot call API');
      return false;
    }
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastApiCallTime < 1000) {
      debugPrint('Throttling API calls');
      return false;
    }

    _lastApiCallTime = currentTime;
    _apiCallCount++;

    debugPrint('Checking payment status - Call #$_apiCallCount/$_maxApiCalls');

    try {
      final response = await http.get(
        Uri.parse('http://192.168.194.242:8081/api/payments/payment-status?orderId=${widget.orderId}'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: _apiTimeoutSeconds)); 

      debugPrint('API response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentStatus = data['data']?['paymentStatus'] ?? false;
        debugPrint('Payment status from API: $paymentStatus');
        setState(() {
          _paymentStatus = paymentStatus;
        });
        return _paymentStatus;
      } else {
        debugPrint('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error checking payment status (Call #$_apiCallCount): $e');
    }
    return false;
  }

  Future<void> _handlePaymentResult(String type, Map<String, dynamic> data) async {
    if (_hasHandledResult) return;
    _loadingTimer?.cancel();
    _pollingTimer?.cancel();
    _hasHandledResult = true;

    debugPrint('Handling payment result: $type after $_apiCallCount API calls');

    if (mounted) {
      switch (type) {
        case 'success':
          widget.onSuccess?.call();
          debugPrint('Navigating to orderSuccess');
          Provider.of<OrderProvider>(context, listen: false).setOrderId(widget.orderId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('orderSuccess');
          });
          break;
        case 'cancel':
          widget.onCancel?.call();
          debugPrint('Payment cancelled, navigating to home');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('home');
          });
          break;
        case 'timeout':
        case 'exit':
          widget.onExit?.call();
          debugPrint('Payment timeout or exited after ${_maxTimeoutMinutes} minutes, navigating to home');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('home');
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) _handlePaymentResult('exit', {});
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF0A0A23),
          appBar: BeautifulAppBar(
            title: 'PayOS Payment',
            gradient: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: _showPaymentInstructionsDialog,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6E56CF),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0A0A23), Color(0xFF1E1E3F)],
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6,
                      width: MediaQuery.of(context).size.width * _loadingAnimation.value,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6E56CF), Color(0xFFA855F7)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A23),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF6E56CF),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: WebViewWidget(controller: _controller),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: AnimatedScale(
                        scale: _isLoading ? 1.0 : 1.05,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6E56CF),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6E56CF).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.security,
                                size: 16,
                                color: Color(0xFF34C759),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Secure Payment Guaranteed',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.85),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) => Transform.scale(
                          scale: 1.0 + (_animationController.value * 0.1),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A23),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: const Color(0xFF6E56CF),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6E56CF).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6E56CF),
                                  ),
                                  child: const Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Shimmer.fromColors(
                                  baseColor: const Color(0xFF6E56CF),
                                  highlightColor: const Color(0xFFA855F7),
                                  period: const Duration(seconds: 2),
                                  child: Text(
                                    'Processing Payment...',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Please wait up to $_maxTimeoutMinutes minutes\nChecking status... (${_apiCallCount}/$_maxApiCalls)',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
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

  void _showPaymentInstructionsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A23),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFF6E56CF),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6E56CF).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6E56CF),
                ),
                child: const Icon(
                  Icons.mobile_friendly_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Instructions',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Extended processing time: up to $_maxTimeoutMinutes minutes',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF34C759),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E3F),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF6E56CF).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInstructionStep(1, 'Select payment method', Icons.credit_card),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInstructionStep(2, 'Enter information', Icons.edit_document),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInstructionStep(3, 'Scan QR and pay', Icons.qr_code),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInstructionStep(4, 'Wait for confirmation', Icons.hourglass_empty),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E56CF),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6E56CF).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Understood',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
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

  Widget _buildInstructionStep(int number, String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6E56CF),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.white.withOpacity(0.8)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}