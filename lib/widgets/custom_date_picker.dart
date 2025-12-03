import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Color selectedColor;
  final Color todayBorderColor;
  final int daysToShow;
  final Map<DateTime, List<Color>>? eventDots;

  const HorizontalDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    this.selectedColor = Colors.green,
    this.todayBorderColor = Colors.blue,
    this.daysToShow = 10,
    this.eventDots,
  }) : super(key: key);

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime _selectedDate;
  late DateTime displayedMonth;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(HorizontalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
      displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
      _scrollToSelectedDate();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final daysSinceStart = _selectedDate.difference(firstDayOfMonth).inDays;

    if (daysSinceStart >= 0 && daysSinceStart < 31) {
      final scrollPosition = (daysSinceStart * 85.0) - (MediaQuery.of(context).size.width / 2) + 40;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollPosition.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDay = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;

    List<DateTime> days = [];
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(displayedMonth.year, displayedMonth.month, day));
    }

    return days;
  }

  List<Color> _getEventDotsForDate(DateTime date) {
    if (widget.eventDots == null || widget.eventDots!.isEmpty) return [];

    // Normalize the date to compare (remove time component)
    final normalizedDate = DateTime(date.year, date.month, date.day);

    for (var entry in widget.eventDots!.entries) {
      final normalizedEntryDate = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (_isSameDate(normalizedEntryDate, normalizedDate)) {
        debugPrint('Found dots for $normalizedDate: ${entry.value.length} dots');
        return entry.value;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    final monthYear = DateFormat('MMM yyyy').format(displayedMonth);
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month/Year Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Optional: Add month/year picker dialog
                },
                child: Text(
                  monthYear,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
                  });
                },
              ),
            ],
          ),
        ),

        // Horizontal Date Scroll
        SizedBox(
          height: 110,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isToday = _isSameDate(date, today);
              final isSelected = _isSameDate(date, _selectedDate);
              final eventDots = _getEventDotsForDate(date);
              final hasEvents = eventDots.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                        widget.onDateSelected(date);
                      },
                      child: Container(
                        width: 73,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEAFFF4) // Light green when selected
                              : Colors.white, // White when not selected
                          border: Border.all(
                            color: isToday
                                ? widget.todayBorderColor
                                : (isSelected
                                ? const Color(0xFF2E7D5E) // Primary color when selected
                                : const Color(0xFFC7C5C5)), // Border color when not selected
                            width: isToday ? 2.5 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date),
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? const Color(0xFF2E7D5E) // Primary color when selected
                                    : const Color(0xFF939292), // Gray when not selected
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Plus Jakarta Sans',
                                height: 1.6,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('dd').format(date),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Plus Jakarta Sans',
                                color: isSelected
                                    ? const Color(0xFF2E7D5E) // Primary color when selected
                                    : const Color(0xFF939292), // Gray when not selected
                                height: 1.6,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Event dots
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 12,
                      child: hasEvents
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: eventDots.take(3).map((color) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}