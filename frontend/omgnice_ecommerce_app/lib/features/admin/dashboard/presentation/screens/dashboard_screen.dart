import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrinkSalesStatsPage extends StatefulWidget {
  const DrinkSalesStatsPage({super.key});

  @override
  State<DrinkSalesStatsPage> createState() => _DrinkSalesStatsPageState();
}

class _DrinkSalesStatsPageState extends State<DrinkSalesStatsPage> {
  // Khai báo controller, form key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    _setDefaultDates();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  // Đặt ngày mặc định: từ 7 ngày trước đến hôm nay
  void _setDefaultDates() {
    setState(() {
      fromDate = DateTime.now().subtract(const Duration(days: 7));
      toDate = DateTime.now();
      _fromDateController.text = _formatDate(fromDate!);
      _toDateController.text = _formatDate(toDate!);
    });
  }

  // Format: 10/05/2025
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Widget chọn ngày
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required DateTime? initialDate,
    required Function(DateTime) onDateSelected,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Chọn ngày' : null,
    );
  }

  // Form chọn ngày
  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: _buildDateField(
                controller: _fromDateController,
                label: 'From Date',
                initialDate: fromDate,
                onDateSelected: (picked) {
                  setState(() {
                    fromDate = picked;
                    _fromDateController.text = _formatDate(picked);
                    if (toDate != null && toDate!.isBefore(fromDate!)) {
                      toDate = fromDate;
                      _toDateController.text = _formatDate(toDate!);
                    }
                  });

                  // TODO: FetchData
                  
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                controller: _toDateController,
                label: 'To Date',
                initialDate: toDate,
                onDateSelected: (picked) {
                  setState(() {
                    toDate = picked;
                    _toDateController.text = _formatDate(picked);
                    if (fromDate != null && toDate!.isBefore(fromDate!)) {
                      fromDate = toDate;
                      _fromDateController.text = _formatDate(fromDate!);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink Sales Stats'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateFilter(),
            
            // TODO: Thêm các phần tiếp theo: TimeFrame, Chart, API...
          ],
        ),
      ),
    );
  }
}
