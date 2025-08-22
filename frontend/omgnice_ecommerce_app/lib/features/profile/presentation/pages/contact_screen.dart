import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/providers/profileProvider.dart';
import 'package:provider/provider.dart';
 final Color backgroundLightColor = const Color(0xFFF1F8E9); // Light Green Background
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();
  final _orderCodeController = TextEditingController();
  PlatformFile? _attachment;
  DateTime _timestamp = DateTime.now();
  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _attachment = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: ${e.toString()}')),
      );
    }
  }

  void _resetForm() {
    _fullNameController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _messageController.clear();
    _subjectController.clear();
    _orderCodeController.clear();
    setState(() {
      _attachment = null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        _timestamp = DateTime.now();
        final formData = {
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'email': _emailController.text,
          'message': _messageController.text,
          'subject': _subjectController.text,
          'orderCode': _orderCodeController.text,
          'attachment': _attachment?.name,
          'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(_timestamp),
        };

        print(formData);
        await Future.delayed(const Duration(seconds: 1));

        Provider.of<ProfileProvider>(context, listen: false).submitContactForm(
            fullName: _fullNameController.text,
            phoneNumber: _phoneNumberController.text,
            email: _emailController.text,
            subject: _subjectController.text,
            message: _messageController.text,
            attachment: _attachment);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact submitted successfully!')),
          );
        }

        _resetForm();
        _formKey.currentState!.reset();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _subjectController.dispose();
    _orderCodeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: BeautifulAppBar(
        title: 'Contact Us',
        gradient: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5, right: 5),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                // border: Border.all(color: Colors.grey.shade200,),
              ),
              child: IconButton(
                  onPressed: () {
                    // Todo: Show Return Home ....
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                        contentPadding: const EdgeInsets.all(24),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home_outlined,
                                color: Colors.green[700], size: 40),
                            const SizedBox(height: 16),
                            Text(
                              'Do you want to return home ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        actionsPadding:
                            const EdgeInsets.only(bottom: 16, right: 16),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<ScreenManager>(context, listen: false).goToHome(); 
                              context.goNamed('home');                          
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Yes',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Full Name *',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneNumberController,
                        label: 'Phone Number *',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\+?[0-9]\d{8,14}$').hasMatch(value)) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Invalid email address';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _subjectController,
                        label: 'Subject',
                        icon: Icons.subject,
                      ),
                      const SizedBox(height: 20),
                      /*   _buildTextField(
                        controller: _orderCodeController,
                        label: 'Order Code',
                        icon: Icons.shopping_cart,
                      ), */
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _messageController,
                        label: 'Message *',
                        icon: Icons.message,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildAttachmentSection(),
                      const SizedBox(height: 32),
                      AnimatedScale(
                        scale: _isSubmitting ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor:
                                const Color.fromARGB(255, 13, 114, 32),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color.fromARGB(255, 22, 121, 52)
                                .withOpacity(0.3),
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 10),
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          prefixIcon: icon != null
              ? Icon(icon, color: const Color.fromARGB(255, 11, 94, 16))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 11, 71, 48), width: 1.5),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attachment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color.fromARGB(255, 10, 40, 64),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _attachment != null
                        ? 'File: ${_attachment!.name} (${_formatFileSize(_attachment!.size)})'
                        : 'No file selected',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _attachment != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(
                    Icons.attach_file,
                    size: 20,
                    color: Colors.green,
                  ),
                  label: Text('Pick File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 6, 207, 16).withOpacity(0.1),
                    foregroundColor: const Color.fromARGB(255, 3, 34, 59),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
