import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class AdvancedDeliveryTimeWidget extends StatefulWidget {
  final Function(DateTime selectedDate, String selectedTime, double deliveryFee) onTimeSelected;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDarkMode;
  final List<String> popularTimes;
  final Map<String, double> timeBasedFees;
  final int availableDays;

  const AdvancedDeliveryTimeWidget({
    Key? key,
    required this.onTimeSelected,
    this.primaryColor = const Color(0xFF4CAF50),
    this.secondaryColor = const Color(0xFF2E7D32),
    this.isDarkMode = false,
    this.popularTimes = const ['08:00 - 10:00', '12:00 - 14:00', '18:00 - 20:00'],
    this.timeBasedFees = const {
      '06:00 - 08:00': 5.0,
      '08:00 - 10:00': 2.5,
      '10:00 - 12:00': 0.0,
      '12:00 - 14:00': 0.0,
      '14:00 - 16:00': 0.0,
      '16:00 - 18:00': 2.5,
      '18:00 - 20:00': 3.5,
      '20:00 - 22:00': 5.0,
    },
    this.availableDays = 7,
  }) : super(key: key);

  @override
  State<AdvancedDeliveryTimeWidget> createState() => _AdvancedDeliveryTimeWidgetState();
}

class _AdvancedDeliveryTimeWidgetState extends State<AdvancedDeliveryTimeWidget> with SingleTickerProviderStateMixin {
  late DateTime selectedDate;
  String? selectedTime;
  late PageController _dateController;
  late TabController _tabController;
  late double deliveryFee = 0.0;
  bool _isExpanded = false;
  
  Color get _cardBgColor => widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textColor => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get _subtleTextColor => widget.isDarkMode ? Colors.white70 : Colors.black54;
  Color get _chipColor => widget.isDarkMode ? Color(0xFF2D2D2D) : Colors.grey.shade100;
  
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _dateController = PageController(initialPage: 0, viewportFraction: 0.2);
    _tabController = TabController(length: 2, vsync: this);
    
    // Pre-select first time slot if available
    if (widget.timeBasedFees.isNotEmpty) {
      selectedTime = widget.timeBasedFees.keys.first;
      deliveryFee = widget.timeBasedFees[selectedTime] ?? 0.0;
      _notifySelection();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  void _notifySelection() {
    if (selectedTime != null) {
      widget.onTimeSelected(selectedDate, selectedTime!, deliveryFee);
    }
  }

  List<DateTime> _getAvailableDates() {
    final List<DateTime> dates = [];
    final DateTime now = DateTime.now();
    
    for (int i = 0; i < widget.availableDays; i++) {
      dates.add(DateTime(now.year, now.month, now.day + i));
    }
    return dates;
  }

  String _formatDayLabel(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final availableDates = _getAvailableDates();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: widget.isDarkMode
            ? [BoxShadow(color: Colors.black45, blurRadius: 15, spreadRadius: 1)]
            : [BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2, offset: Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header with animation
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.primaryColor, widget.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Delivery Schedule',
                          style: TextStyle(
                            fontSize: size.width * 0.042,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (selectedTime != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              selectedTime!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: _isExpanded ? 0.5 : 0),
                          duration: Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.rotate(
                              angle: value * math.pi,
                              child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Expandable content
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
              firstChild: Container(height: 0),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date selector
                  Container(
                    height: 100,
                    child: PageView.builder(
                      controller: _dateController,
                      itemCount: availableDates.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedDate = availableDates[index];
                          _notifySelection();
                        });
                      },
                      itemBuilder: (context, index) {
                        final date = availableDates[index];
                        final isSelected = date.day == selectedDate.day &&
                                          date.month == selectedDate.month &&
                                          date.year == selectedDate.year;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                              _dateController.animateToPage(
                                index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              _notifySelection();
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? widget.primaryColor 
                                  : _chipColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: isSelected
                                  ? [BoxShadow(
                                      color: widget.primaryColor.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    )]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatDayLabel(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: isSelected 
                                        ? Colors.white 
                                        : _subtleTextColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: isSelected 
                                        ? Colors.white 
                                        : _textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                
                  // Tab controller for switching between time views
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: widget.primaryColor,
                      labelColor: widget.primaryColor,
                      unselectedLabelColor: _subtleTextColor,
                      tabs: [
                        Tab(text: 'Time Slots'),
                        Tab(text: 'Popular Times'),
                      ],
                    ),
                  ),
                  
                  // Tab content
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Time slots grid
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: widget.timeBasedFees.length,
                            itemBuilder: (context, index) {
                              final time = widget.timeBasedFees.keys.elementAt(index);
                              final fee = widget.timeBasedFees[time]!;
                              final bool isSelected = time == selectedTime;
                              
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = time;
                                    deliveryFee = fee;
                                    _notifySelection();
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? widget.primaryColor : _chipColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? widget.primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [BoxShadow(
                                            color: widget.primaryColor.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          )]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        time,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : _textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isSelected 
                                              ? Colors.white.withOpacity(0.2) 
                                              : (fee > 0 ? Colors.amber.withOpacity(0.2) : Colors.green.withOpacity(0.2)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          fee > 0 ? '+\$${fee.toStringAsFixed(2)}' : 'Free',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: isSelected 
                                                ? Colors.white 
                                                : (fee > 0 ? Colors.amber.shade800 : Colors.green.shade700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Popular times
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Most popular delivery times:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _textColor,
                                ),
                              ),
                              SizedBox(height: 16),
                              ...widget.popularTimes.map((time) {
                                final bool isSelected = time == selectedTime;
                                final fee = widget.timeBasedFees[time] ?? 0.0;
                                
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTime = time;
                                      deliveryFee = fee;
                                      _notifySelection();
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? widget.primaryColor : _chipColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isSelected
                                          ? [BoxShadow(
                                              color: widget.primaryColor.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            )]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_fire_department_rounded,
                                              color: isSelected ? Colors.white : Colors.orange,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isSelected ? Colors.white : _textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? Colors.white.withOpacity(0.2) 
                                                : (fee > 0 ? Colors.amber.withOpacity(0.2) : Colors.green.withOpacity(0.2)),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            fee > 0 ? '+\$${fee.toStringAsFixed(2)}' : 'Free',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: isSelected 
                                                  ? Colors.white 
                                                  : (fee > 0 ? Colors.amber.shade800 : Colors.green.shade700),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Selected time summary
                  if (selectedTime != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode ? Color(0xFF2A2A2A) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_shipping_rounded,
                              color: widget.primaryColor,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery on ${DateFormat('EEEE, MMMM d').format(selectedDate)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _textColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$selectedTime ${deliveryFee > 0 ? "• \$${deliveryFee.toStringAsFixed(2)} delivery fee" : "• Free delivery"}',
                                  style: TextStyle(
                                    color: _subtleTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle_rounded,
                            color: widget.primaryColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                
                  // Confirm button
                  if (selectedTime != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          _notifySelection();
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                        
                          elevation: 5,
                          shadowColor: widget.primaryColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Center(
                          child: Text(
                            'CONFIRM DELIVERY TIME',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example of usage
class DeliveryTimeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Schedule'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AdvancedDeliveryTimeWidget(
              onTimeSelected: (date, time, fee) {
                print('Selected date: $date');
                print('Selected time: $time');
                print('Delivery fee: \$${fee.toStringAsFixed(2)}');
              },
              primaryColor: Color(0xFF4CAF50),
              secondaryColor: Color(0xFF2E7D32),
              isDarkMode: false,
              popularTimes: ['08:00 - 10:00', '12:00 - 14:00', '18:00 - 20:00'],
              timeBasedFees: {
                '06:00 - 08:00': 5.0,
                '08:00 - 10:00': 2.5,
                '10:00 - 12:00': 0.0,
                '12:00 - 14:00': 0.0,
                '14:00 - 16:00': 0.0,
                '16:00 - 18:00': 2.5,
                '18:00 - 20:00': 3.5,
                '20:00 - 22:00': 5.0,
              },
              availableDays: 7,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('You can customize the delivery time widget with various theme options'),
                    SizedBox(height: 16),
                    Text('• Different color schemes', style: TextStyle(fontSize: 14)),
                    Text('• Light/dark mode support', style: TextStyle(fontSize: 14)),
                    Text('• Custom time slots and fees', style: TextStyle(fontSize: 14)),
                    Text('• Adjustable available delivery days', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}