// import 'dart:math' as math;
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/color/app_color.dart';
// import '../../bloc/saving/saving_bloc.dart';
// import '../../bloc/saving/saving_state.dart';
//
// class CalendarEntry {
//   final String title;
//   final double amount;
//   final DateTime date;
//   final String category;
//
//   const CalendarEntry({
//     required this.title,
//     required this.amount,
//     required this.date,
//     required this.category,
//   });
// }
//
// class CalendarScreen extends StatefulWidget {
//   final String categoryName;
//   final List<CalendarEntry> entries;
//
//   const CalendarScreen({
//     super.key,
//     required this.categoryName,
//     required this.entries,
//   });
//
//   @override
//   State<CalendarScreen> createState() => _CalendarScreenState();
// }
//
// class _CalendarScreenState extends State<CalendarScreen> {
//   late DateTime _visibleMonth;
//   late DateTime _selectedDate;
//   bool _showCategories = false;
//
//   static const Color _lightBlue = Color(0xFF69B5FF);
//
//   bool get isDark =>
//       Theme.of(context).brightness == Brightness.dark;
//
//   Color get backgroundColor =>
//       isDark ? AppColors.darkBackground : AppColors.primaryGreen;
//
//   Color get surfaceColor =>
//       isDark ? AppColors.darkSurface : AppColors.lightGreen;
//
//   Color get textColor =>
//       isDark ? AppColors.darkText : AppColors.darkGreen;
//
//   Color get secondaryTextColor =>
//       isDark ? AppColors.darkSecondaryText : AppColors.darkGreen;
//
//   Color get mutedSurfaceColor =>
//       isDark ? AppColors.darkCard : const Color(0xFFDDF8E2);
//
//   Color get selectedColor =>
//       isDark ? AppColors.lightGreen : AppColors.primaryGreen;
//
//   Color get selectedTextColor =>
//       isDark ? AppColors.darkBackground : AppColors.darkGreen;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _selectedDate = DateTime.now();
//     _visibleMonth = DateTime(
//       _selectedDate.year,
//       _selectedDate.month,
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // Logic (unchanged)
//   // ---------------------------------------------------------------------------
//
//   List<CalendarEntry> _entriesFromState(SavingsState state) {
//     // Prefer live Firestore/BLoC data when it is available.
//     if (state.savings.isEmpty) {
//       return widget.entries
//           .where(
//             (entry) =>
//         entry.category.toLowerCase() ==
//             widget.categoryName.toLowerCase(),
//       )
//           .toList();
//     }
//
//     return state.savings
//         .where(
//           (saving) =>
//       saving.category.toLowerCase() ==
//           widget.categoryName.toLowerCase(),
//     )
//         .map(
//           (saving) => CalendarEntry(
//         title: saving.title,
//         amount: saving.amount,
//         date: saving.date,
//         category: saving.category,
//       ),
//     )
//         .toList();
//   }
//
//   List<CalendarEntry> _monthEntries(
//       List<CalendarEntry> entries,
//       ) {
//     return entries.where((entry) {
//       return entry.date.year == _visibleMonth.year &&
//           entry.date.month == _visibleMonth.month;
//     }).toList()
//       ..sort((a, b) => b.date.compareTo(a.date));
//   }
//
//   List<CalendarEntry> _selectedDateEntries(
//       List<CalendarEntry> entries,
//       ) {
//     return _monthEntries(entries).where((entry) {
//       return entry.date.year == _selectedDate.year &&
//           entry.date.month == _selectedDate.month &&
//           entry.date.day == _selectedDate.day;
//     }).toList();
//   }
//
//   void _changeMonth(int difference) {
//     setState(() {
//       _visibleMonth = DateTime(
//         _visibleMonth.year,
//         _visibleMonth.month + difference,
//       );
//
//       _selectedDate = DateTime(
//         _visibleMonth.year,
//         _visibleMonth.month,
//         1,
//       );
//     });
//   }
//
//   // Figma has no prev/next arrows, so months change by swiping the grid.
//   void _onSwipe(DragEndDetails details) {
//     final velocity = details.primaryVelocity ?? 0;
//
//     if (velocity > 250) {
//       _changeMonth(-1);
//     } else if (velocity < -250) {
//       _changeMonth(1);
//     }
//   }
//
//   Future<void> _selectMonth() async {
//     final chosen = await showDatePicker(
//       context: context,
//       initialDate: _visibleMonth,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       initialDatePickerMode: DatePickerMode.year,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: AppColors.primaryGreen,
//               brightness:
//               isDark ? Brightness.dark : Brightness.light,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (chosen == null || !mounted) return;
//
//     setState(() {
//       _visibleMonth = DateTime(chosen.year, chosen.month);
//       _selectedDate = chosen;
//     });
//   }
//
//   // ---------------------------------------------------------------------------
//   // UI (matched to Figma)
//   // ---------------------------------------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final scale = (size.width / 375).clamp(0.85, 1.15).toDouble();
//     final bottomInset = MediaQuery.of(context).padding.bottom;
//
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             SizedBox(height: 14 * scale),
//             _buildHeader(scale),
//             SizedBox(height: 58 * scale),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: surfaceColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(55 * scale),
//                     topRight: Radius.circular(55 * scale),
//                   ),
//                 ),
//                 child: BlocBuilder<SavingsBloc, SavingsState>(
//                   builder: (context, state) {
//                     final entries = _entriesFromState(state);
//
//                     return SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.fromLTRB(
//                         32 * scale,
//                         21 * scale,
//                         32 * scale,
//                         28 * scale + bottomInset,
//                       ),
//                       child: Column(
//                         children: [
//                           _buildMonthHeader(scale),
//                           SizedBox(height: 14 * scale),
//                           GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onHorizontalDragEnd: _onSwipe,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 9 * scale,
//                               ),
//                               child: _buildCalendarGrid(scale, entries),
//                             ),
//                           ),
//                           SizedBox(height: 28 * scale),
//                           _buildTabs(scale),
//                           SizedBox(height: 29 * scale),
//                           if (_showCategories)
//                             _buildCategories(scale, entries)
//                           else
//                             _buildRecords(
//                               scale,
//                               _selectedDateEntries(entries),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(double scale) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 30 * scale),
//       child: SizedBox(
//         height: 32 * scale,
//         child: Row(
//           children: [
//             GestureDetector(
//               behavior: HitTestBehavior.opaque,
//               onTap: () => Navigator.pop(context),
//               child: SizedBox(
//                 width: 32 * scale,
//                 height: 32 * scale,
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: isDark ? AppColors.darkText : AppColors.white,
//                     size: 24 * scale,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'Calendar',
//                   style: GoogleFonts.poppins(
//                     fontSize: 17 * scale,
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: 28 * scale,
//               height: 28 * scale,
//               decoration: BoxDecoration(
//                 color: isDark ? AppColors.darkCard : AppColors.lightGreen,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.notifications_none,
//                 size: 17 * scale,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMonthHeader(double scale) {
//     Widget dropdown(String label, VoidCallback onTap) {
//       return InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 2 * scale),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   fontSize: 12.5 * scale,
//                   fontWeight: FontWeight.w500,
//                   color: selectedColor,
//                 ),
//               ),
//               SizedBox(width: 2 * scale),
//               Icon(
//                 Icons.keyboard_arrow_down,
//                 size: 18 * scale,
//                 color: selectedColor,
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 18 * scale),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           dropdown(_monthName(_visibleMonth.month), _selectMonth),
//           dropdown('${_visibleMonth.year}', _selectMonth),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendarGrid(
//       double scale,
//       List<CalendarEntry> entries,
//       ) {
//     const weekdays = [
//       'Mon',
//       'Tue',
//       'Wed',
//       'Thu',
//       'Fri',
//       'Sat',
//       'Sun',
//     ];
//
//     final firstWeekday =
//         DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday;
//
//     final daysInMonth = DateTime(
//       _visibleMonth.year,
//       _visibleMonth.month + 1,
//       0,
//     ).day;
//
//     final totalCells =
//         ((firstWeekday - 1 + daysInMonth + 6) ~/ 7) * 7;
//
//     final datesWithEntries = _monthEntries(entries)
//         .map((entry) => entry.date.day)
//         .toSet();
//
//     return Column(
//       children: [
//         SizedBox(
//           height: 16 * scale,
//           child: Row(
//             children: weekdays.map((day) {
//               return Expanded(
//                 child: Center(
//                   child: Text(
//                     day,
//                     style: GoogleFonts.poppins(
//                       fontSize: 10 * scale,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.blue,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         SizedBox(height: 3 * scale),
//         ...List.generate(totalCells ~/ 7, (week) {
//           return SizedBox(
//             height: 33 * scale,
//             child: Row(
//               children: List.generate(7, (weekdayIndex) {
//                 final cellIndex = week * 7 + weekdayIndex;
//                 final day = cellIndex - (firstWeekday - 1) + 1;
//
//                 if (day < 1 || day > daysInMonth) {
//                   return const Expanded(child: SizedBox.shrink());
//                 }
//
//                 final isSelected = day == _selectedDate.day &&
//                     _visibleMonth.month == _selectedDate.month &&
//                     _visibleMonth.year == _selectedDate.year;
//
//                 final hasEntries = datesWithEntries.contains(day);
//
//                 return Expanded(
//                   child: Center(
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           _selectedDate = DateTime(
//                             _visibleMonth.year,
//                             _visibleMonth.month,
//                             day,
//                           );
//                         });
//                       },
//                       customBorder: const CircleBorder(),
//                       child: Container(
//                         width: 31 * scale,
//                         height: 31 * scale,
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppColors.blue
//                               : Colors.transparent,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Text(
//                               '$day',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 11 * scale,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                                 color: isSelected
//                                     ? AppColors.white
//                                     : textColor,
//                               ),
//                             ),
//                             if (hasEntries && !isSelected)
//                               Positioned(
//                                 bottom: 3 * scale,
//                                 child: Container(
//                                   width: 3,
//                                   height: 3,
//                                   decoration: BoxDecoration(
//                                     color: selectedColor,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildTabs(double scale) {
//     return Row(
//       children: [
//         Expanded(
//           child: _tabButton(
//             label: 'Spends',
//             selected: !_showCategories,
//             scale: scale,
//             onTap: () => setState(() => _showCategories = false),
//           ),
//         ),
//         SizedBox(width: 16 * scale),
//         Expanded(
//           child: _tabButton(
//             label: 'Categories',
//             selected: _showCategories,
//             scale: scale,
//             onTap: () => setState(() => _showCategories = true),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _tabButton({
//     required String label,
//     required bool selected,
//     required double scale,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(22),
//       child: Container(
//         height: 32 * scale,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: selected ? selectedColor : mutedSurfaceColor,
//           borderRadius: BorderRadius.circular(22),
//         ),
//         child: Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 12 * scale,
//             fontWeight: FontWeight.w500,
//             color: selected ? selectedTextColor : textColor,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _verticalDivider(double scale) {
//     return Container(
//       width: 1,
//       height: 32 * scale,
//       color: selectedColor,
//     );
//   }
//
//   Widget _buildRecords(
//       double scale,
//       List<CalendarEntry> entries,
//       ) {
//     if (entries.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.symmetric(vertical: 24 * scale),
//         child: Center(
//           child: Text(
//             'No savings on ${_selectedDate.day} '
//                 '${_monthName(_selectedDate.month)}.',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 11 * scale,
//               color: secondaryTextColor,
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Column(
//       children: List.generate(entries.length, (index) {
//         final entry = entries[index];
//         final boxColor =
//         index.isEven ? AppColors.strongBlue : _lightBlue;
//
//         return Padding(
//           padding: EdgeInsets.only(bottom: 18 * scale),
//           child: Row(
//             children: [
//               Container(
//                 width: 47 * scale,
//                 height: 47 * scale,
//                 decoration: BoxDecoration(
//                   color: boxColor,
//                   borderRadius: BorderRadius.circular(14 * scale),
//                 ),
//                 child: Icon(
//                   _iconFor(entry.category),
//                   color: AppColors.white,
//                   size: 26 * scale,
//                 ),
//               ),
//               SizedBox(width: 16 * scale),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       entry.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.poppins(
//                         fontSize: 11.5 * scale,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                     SizedBox(height: 2 * scale),
//                     Text(
//                       '${_formatTime(entry.date)} - '
//                           '${_monthName(entry.date.month)} ${entry.date.day}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.poppins(
//                         fontSize: 8.5 * scale,
//                         color: AppColors.strongBlue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 8 * scale),
//               _verticalDivider(scale),
//               SizedBox(
//                 width: 78 * scale,
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4 * scale),
//                     child: Text(
//                       entry.category,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontSize: 9 * scale,
//                         color: textColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               _verticalDivider(scale),
//               SizedBox(
//                 width: 74 * scale,
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 10 * scale),
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       '\$${entry.amount.toStringAsFixed(2)}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 11.5 * scale,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildCategories(
//       double scale,
//       List<CalendarEntry> entries,
//       ) {
//     final totals = <String, double>{};
//
//     for (final entry in _monthEntries(entries)) {
//       totals.update(
//         entry.category,
//             (value) => value + entry.amount,
//         ifAbsent: () => entry.amount,
//       );
//     }
//
//     final total = totals.values.fold<double>(
//       0,
//           (sum, amount) => sum + amount,
//     );
//
//     if (totals.isEmpty || total <= 0) {
//       return Padding(
//         padding: EdgeInsets.symmetric(vertical: 24 * scale),
//         child: Text(
//           'No category records for ${_monthName(_visibleMonth.month)}.',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.poppins(
//             fontSize: 11 * scale,
//             color: secondaryTextColor,
//           ),
//         ),
//       );
//     }
//
//     final colors = [
//       AppColors.blue,
//       AppColors.strongBlue,
//       _lightBlue,
//       AppColors.primaryGreen,
//     ];
//
//     final items = totals.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
//
//     return Column(
//       children: [
//         SizedBox(
//           width: 245 * scale,
//           height: 123 * scale,
//           child: CustomPaint(
//             painter: _CategoryPiePainter(
//               values: items.map((item) => item.value).toList(),
//               colors: colors,
//               separatorColor: surfaceColor,
//               labelStyle: GoogleFonts.poppins(
//                 fontSize: 13 * scale,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 16 * scale),
//         Wrap(
//           alignment: WrapAlignment.center,
//           spacing: 24 * scale,
//           runSpacing: 8 * scale,
//           children: List.generate(items.length, (index) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 7 * scale,
//                   height: 7 * scale,
//                   decoration: BoxDecoration(
//                     color: colors[index % colors.length],
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 6 * scale),
//                 Text(
//                   items[index].key,
//                   style: GoogleFonts.poppins(
//                     fontSize: 10.5 * scale,
//                     fontWeight: FontWeight.w500,
//                     color: textColor,
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   static IconData _iconFor(String category) {
//     final name = category.toLowerCase();
//
//     if (name.contains('travel')) return Icons.flight_outlined;
//     if (name.contains('house')) return Icons.home_work_outlined;
//     if (name.contains('car')) return Icons.directions_car_outlined;
//     if (name.contains('wedding')) return Icons.celebration_outlined;
//
//     return Icons.savings_outlined;
//   }
//
//   String _formatTime(DateTime date) {
//     final hour = date.hour.toString().padLeft(2, '0');
//     final minute = date.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
//
//   String _monthName(int month) {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//
//     return months[month - 1];
//   }
// }
//
// /// Half pie (semicircle) with white separators and % labels, like Figma.
// class _CategoryPiePainter extends CustomPainter {
//   final List<double> values;
//   final List<Color> colors;
//   final Color separatorColor;
//   final TextStyle labelStyle;
//
//   _CategoryPiePainter({
//     required this.values,
//     required this.colors,
//     required this.separatorColor,
//     required this.labelStyle,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (values.isEmpty || colors.isEmpty) return;
//
//     final total = values.fold<double>(
//       0,
//           (sum, value) => sum + value,
//     );
//
//     if (total <= 0) return;
//
//     final radius = math.min(size.width / 2, size.height);
//     final center = Offset(size.width / 2, size.height);
//     final rect = Rect.fromCircle(center: center, radius: radius);
//
//     final fill = Paint()
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;
//
//     final separator = Paint()
//       ..color = separatorColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..isAntiAlias = true;
//
//     var startAngle = math.pi;
//
//     for (var i = 0; i < values.length; i++) {
//       final sweepAngle = math.pi * values[i] / total;
//
//       fill.color = colors[i % colors.length];
//
//       canvas.drawArc(
//         rect,
//         startAngle,
//         sweepAngle,
//         true,
//         fill,
//       );
//
//       // Separator between slices (not at the two outer edges).
//       if (i > 0) {
//         canvas.drawLine(
//           center,
//           center +
//               Offset(
//                 math.cos(startAngle) * radius,
//                 math.sin(startAngle) * radius,
//               ),
//           separator,
//         );
//       }
//
//       final percentage = values[i] / total * 100;
//
//       if (percentage >= 4) {
//         final mid = startAngle + sweepAngle / 2;
//         final labelCenter = center +
//             Offset(
//               math.cos(mid) * radius * 0.62,
//               math.sin(mid) * radius * 0.62,
//             );
//
//         final painter = TextPainter(
//           text: TextSpan(
//             text: '${percentage.round()}%',
//             style: labelStyle,
//           ),
//           textDirection: TextDirection.ltr,
//         )..layout();
//
//         painter.paint(
//           canvas,
//           labelCenter - Offset(painter.width / 2, painter.height / 2),
//         );
//       }
//
//       startAngle += sweepAngle;
//     }
//   }
//
//   @override
//   bool shouldRepaint(
//       covariant _CategoryPiePainter oldDelegate,
//       ) {
//     return !listEquals(oldDelegate.values, values) ||
//         !listEquals(oldDelegate.colors, colors) ||
//         oldDelegate.separatorColor != separatorColor;
//   }
// }