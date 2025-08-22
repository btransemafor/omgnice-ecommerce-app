import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/notification/presentation/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';

class BroadcastNotificationScreen extends StatefulWidget {
  const BroadcastNotificationScreen({Key? key}) : super(key: key);

  @override
  State<BroadcastNotificationScreen> createState() =>
      _BroadcastNotificationScreenState();
}

class _BroadcastNotificationScreenState
    extends State<BroadcastNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isBroadcast = true;
  String? _selectedUserId;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => _fetchError = null);
    try {
      await userProvider.fetchAllUsers();
    } catch (e) {
      setState(() => _fetchError = "Failed to fetch users: $e");
    }
  }

  Future<void> _sendNotification(BuildContext context) async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      _showErrorSnackBar("Please enter both title and message");
      return;
    }

    if (!_isBroadcast && _selectedUserId == null) {
      _showErrorSnackBar("Please select a user");
      return;
    }

    final confirm = await _showConfirmationDialog();
    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final Map<String, String> contentNoti = {
        'title': title,
        'message': message,
      };

      if (_isBroadcast) {
        contentNoti['broadcast'] = "true";
      } else {
        contentNoti['user_id'] = _selectedUserId as String;
      }

      await Provider.of<NotificationProvider>(context, listen: false)
          .createNotifilcation(contentNoti);
      if (Provider.of<NotificationProvider>(context, listen: false).isSucess) {
        _showSuccessSnackBar('Notification was sent successfully!');
      }
    } catch (e) {
      _showErrorSnackBar("Error sending notification: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          'Confirm Notification',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
        ),
        content: Text(
          'Are you sure you want to send this notification?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Send',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          title: Text(
            "Send Notification",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          leading: Container(
            padding: EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          )),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final validUsers = userProvider.users
              .where((user) => user.name != null && user.name!.isNotEmpty)
              .toList();

          return Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_fetchError != null)
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _fetchError!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _fetchUsers,
                                    child: Text(
                                      'Retry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green.shade50,
                                radius: 20,
                                child: Icon(
                                  Icons.notifications_active,
                                  color: Colors.green.shade700,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Create New Notification",
                                    style: GoogleFonts.poppins(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Manage your notifications",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Send Mode",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBroadcast = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _isBroadcast
                                            ? Colors.green.shade100
                                            : Colors.transparent,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                          left: Radius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            color: _isBroadcast
                                                ? Colors.green.shade700
                                                : Colors.grey.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "All Users",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: _isBroadcast
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBroadcast = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !_isBroadcast
                                            ? Colors.green.shade100
                                            : Colors.transparent,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                          right: Radius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: !_isBroadcast
                                                ? Colors.green.shade700
                                                : Colors.grey.shade600,
                                            size: 20,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Specific User",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: !_isBroadcast
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade600,
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
                          const SizedBox(height: 20),
                          if (!_isBroadcast) ...[
                            Text(
                              "Select User",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.white,
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedUserId,
                                decoration: InputDecoration(
                                  hintText: "Choose a recipient",
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.green.shade600, size: 20),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                                isExpanded: true,
                                items: validUsers.isEmpty
                                    ? [
                                        DropdownMenuItem(
                                          value: null,
                                          child: Text(
                                            "No valid users found",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : validUsers.map((user) {
                                        return DropdownMenuItem(
                                          value: user.id,
                                          child: Text(
                                            user.name!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                onChanged: validUsers.isEmpty
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedUserId = val;
                                        });
                                      },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Text(
                            "Title",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: "Enter notification title",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.green.shade400, width: 1.5),
                              ),
                              prefixIcon: Icon(
                                Icons.title,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Message",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter detailed message...",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.green.shade400, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_titleController.text.isNotEmpty ||
                              _messageController.text.isNotEmpty) ...[
                            Text(
                              "Preview",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _titleController.text.isEmpty
                                        ? "No title"
                                        : _titleController.text,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _messageController.text.isEmpty
                                        ? "No message"
                                        : _messageController.text,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _sendNotification(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                shadowColor: Colors.green.shade200,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.send_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Send Notification',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          if (userProvider.isLoading && _fetchError == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.green.shade600,
                                      strokeWidth: 2,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Loading user list...",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
