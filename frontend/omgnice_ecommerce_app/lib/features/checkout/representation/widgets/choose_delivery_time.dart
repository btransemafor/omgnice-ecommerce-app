import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // thêm dòng này để dùng Poppins
import 'package:intl/intl.dart';

class ChooseDeliveryTimeWidget extends StatefulWidget {
  final List<String> timeOptions;
  final Function(String selectedTime) onSelected;

  const ChooseDeliveryTimeWidget({
    Key? key,
    required this.timeOptions,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<ChooseDeliveryTimeWidget> createState() => _ChooseDeliveryTimeWidgetState();
}

class _ChooseDeliveryTimeWidgetState extends State<ChooseDeliveryTimeWidget> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Delivery Time',
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.036,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.timeOptions.map((time) {
              final bool isSelected = time == selectedTime;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTime = time;
                  });
                  widget.onSelected(time);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.shade400
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    time,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedTime != null)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.green.withOpacity(0.9),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You selected time: $selectedTime',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: const Color.fromARGB(255, 20, 230, 24),
                    size: 24,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
