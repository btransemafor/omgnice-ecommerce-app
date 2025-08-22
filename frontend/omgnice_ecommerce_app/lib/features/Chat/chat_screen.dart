import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Add Markdown support

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late AnimationController _typingController;

 
  final Map<int, AnimationController> _bubbleControllers = {};


  final Map<int, AnimationController> _textAnimationControllers = {};


  final double _typingSpeed = 20.0;


  final List<List<Color>> _availableGradients = [
    [const Color(0xFF6A11CB), const Color(0xFF2575FC)], // Default
    [const Color.fromARGB(255, 35, 69, 87), const Color(0xFF0077B6)], 
    [const Color(0xFFFF6B6B), const Color(0xFFFFA14F)], 
    [const Color.fromARGB(255, 17, 83, 44), const Color(0xFF27AE60)], 
  ];

 
  List<Color> _gradientColors = [
    const Color(0xFF6A11CB),
    const Color(0xFF2575FC),
  ];

  final Color _userBubbleColor = const Color(0xFF3E64FF);
  final Color _botBubbleColor = const Color(0xFFF5F5F5);
  final Color _userTextColor = Colors.white;
  final Color _botTextColor = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  String _getTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final messageIndex = _messages.length;
    final userMessage = {
      'role': 'user',
      'text': message,
      'time': _getTime(),
      'isAnimated': true,
      'index': messageIndex,
    };

    setState(() {
      _isLoading = true;
      _messages.add(userMessage);
    });

   
    _createBubbleController(messageIndex);

    _scrollToBottom();
    _controller.clear();
    FocusScope.of(context).unfocus();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.8:8081/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': message}),
      ).timeout(const Duration(seconds: 40));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String botResponse = data['result'];

        final botMessageIndex = _messages.length;
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': botResponse,
            'time': _getTime(),
            'isAnimated': true,
            'index': botMessageIndex,
          });
          _isLoading = false;
        });
        _createBubbleController(botMessageIndex);
        _createTextAnimationController(botMessageIndex, botResponse);

        _scrollToBottom();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      final errorMessageIndex = _messages.length;
      final String errorMessage = 'Error: Unable to get response. Please try again.';

      setState(() {
        _messages.add({
          'role': 'bot',
          'text': errorMessage,
          'time': _getTime(),
          'isAnimated': true,
          'index': errorMessageIndex,
        });
        _isLoading = false;
      });

      _createBubbleController(errorMessageIndex);

      _createTextAnimationController(errorMessageIndex, errorMessage);

      _scrollToBottom();
    }
  }

  void _createBubbleController(int index) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bubbleControllers[index] = controller;

    controller.forward();
  }

  void _createTextAnimationController(int index, String text) {
    if (_messages[index]['role'] != 'bot') return;

    final int charCount = text.length;
    final double durationInSeconds = charCount / _typingSpeed;

    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (durationInSeconds * 1000).toInt()),
    );

    _textAnimationControllers[index] = controller;

    controller.forward();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showBackgroundPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Choose Background',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _availableGradients.asMap().entries.map((entry) {
              final index = entry.key;
              final gradient = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _gradientColors = gradient;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Background ${index + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.notoSans(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _typingController.dispose();

    for (final controller in _bubbleControllers.values) {
      controller.dispose();
    }

    for (final controller in _textAnimationControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: _buildMessageList(),
                  ),
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.assistant,
              color: Color(0xFF6A11CB),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Smart Assistant",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 7, 101, 12),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Online",
                      style: GoogleFonts.notoSans(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            onPressed: _showBackgroundPicker,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final msg = _messages[i];
        final isUser = msg['role'] == 'user';
        final index = msg['index'] as int;

        final controller = _bubbleControllers[index];

        if (controller == null) {
          return _buildMessageBubble(msg, isUser);
        }

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: controller,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(isUser ? 0.3 : -0.3, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeOutQuad,
                )),
                child: _buildMessageBubble(msg, isUser),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isUser) {
    final index = msg['index'] as int;
    final fullText = msg['text'] ?? '';

    final AnimationController? textController = !isUser ? _textAnimationControllers[index] : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isUser ? _userBubbleColor : _botBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textController != null
                      ? AnimatedBuilder(
                          animation: textController,
                          builder: (context, child) {
                            final textLength = (fullText.length * textController.value).round();
                            final displayText = fullText.substring(0, textLength);
                            final showCursor = textController.value < 1.0;

                            return MarkdownBody(
                              data: displayText + (showCursor ? '|' : ''),
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.mulish(
                                  color: _botTextColor,
                                  fontSize: 14,
                                ),
                                strong: GoogleFonts.mulish(
                                  color: _botTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        )
                      : isUser
                          ? Text(
                              fullText,
                              style: GoogleFonts.notoSans(
                                color: _userTextColor,
                                fontSize: 14,
                              ),
                            )
                          : MarkdownBody(
                              data: fullText,
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.mulish(
                                  color: _botTextColor,
                                  fontSize: 14,
                                ),
                                strong: GoogleFonts.mulish(
                                  color: _botTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      msg['time'] ?? '',
                      style: GoogleFonts.notoSans(
                        color: isUser ? Colors.white70 : Colors.grey[600],
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 4),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 12,
      backgroundColor: Color(0xFF6A11CB),
      child: Icon(
        Icons.assistant,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return const CircleAvatar(
      radius: 12,
      backgroundColor: Color(0xFF3E64FF),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _botBubbleColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedBuilder(
                    animation: _typingController,
                    builder: (context, child) {
                      final double scale = 1.0 + 0.3 * sin((_typingController.value * 3.14) + (index * 0.5));
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6A11CB),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.white.withOpacity(0.95),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            children: [
              if (_isLoading) _buildTypingIndicator(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: Color(0xFF6A11CB), size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter message...',
                          hintStyle: GoogleFonts.notoSans(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _sendMessage(_controller.text),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _gradientColors,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}