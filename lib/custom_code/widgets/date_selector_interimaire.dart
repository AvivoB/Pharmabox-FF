import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constant.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class DateSelector extends StatefulWidget {
  final ValueChanged<List<String>> onDatesChanged;
  final List initialSelectedDates;
  final bool isEditable;

  DateSelector({required this.onDatesChanged, this.initialSelectedDates = const [], this.isEditable = true});

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  List<DateTime> selectedDates = [];

  // static const List<String> weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  // static const List<String> months = ['', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];

  // late DateTime startSwipeDate;
  // bool isDragging = false;

  // void _toggleDate(DateTime date) {
  //   if (date.isAfter(currentDate.subtract(Duration(days: 1)))) {
  //     if (selectedDates.contains(date)) {
  //       selectedDates.remove(date);
  //     } else {
  //       selectedDates.add(date);
  //     }
  //     widget.onDatesChanged(selectedDates); // notifier le widget parent
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // for (var date in widget.initialSelectedDates) {
    //   selectedDates.add(DateTime(date.toDate().year, date.toDate().month, date.toDate().day));
    // }

    for (var date in widget.initialSelectedDates) {
      // Divisez la date en parties pour extraire le jour, le mois et l'année
      List<String> dateParts = date.split('/');
      
      // Convertissez chaque partie en entier
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);
      
      // Ajoutez la date convertie à la liste
      selectedDates.add(DateTime(year, month, day));
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         IconButton(
    //           icon: Icon(Icons.arrow_back),
    //           onPressed: () {
    //             setState(() {
    //               selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
    //             });
    //           },
    //         ),
    //         Text(
    //           "${months[selectedDate.month]} ${selectedDate.year}",
    //           style: FlutterFlowTheme.of(context).bodyMedium,
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.arrow_forward),
    //           onPressed: () {
    //             setState(() {
    //               selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    //             });
    //           },
    //         ),
    //       ],
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: weekdays
    //           .map((day) => Expanded(
    //                   child: Center(
    //                       child: Text(
    //                 day,
    //                 style: FlutterFlowTheme.of(context).bodySmall,
    //               ))))
    //           .toList(),
    //     ),
    //     Expanded(
    //       child: GestureDetector(
    //           onPanStart: (details) {
    //             isDragging = true;
    //             _handlePan(details.localPosition);
    //           },
    //           onPanUpdate: (details) {
    //             _handlePan(details.localPosition);
    //           },
    //           onPanEnd: (details) {
    //             isDragging = false;
    //           },
    //           child: GridView.builder(
    //             physics: NeverScrollableScrollPhysics(),
    //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 7,
    //             ),
    //             itemBuilder: (context, index) {
    //               final day = index - (selectedDate.weekday - 1) + 1;
    //               final itemDate = DateTime(selectedDate.year, selectedDate.month, day);

    //               if (day <= 0 || day > daysInMonth(selectedDate)) {
    //                 return Container(); // Empty cell
    //               }

    //               final isSelectable = itemDate.isAfter(currentDate.subtract(Duration(days: 1)));
    //               final isPastDate = itemDate.isBefore(currentDate.subtract(Duration(days: 1)));

    //               return GestureDetector(
    //                 onTap: () {
    //                   if (isSelectable) {
    //                     setState(() {
    //                       if (widget.isEditable) _toggleDate(itemDate);
    //                     });
    //                   }
    //                 },
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(2.0),
    //                   child: Container(
    //                     alignment: Alignment.center,
    //                     decoration: BoxDecoration(
    //                       color: selectedDates.contains(itemDate) ? (isPastDate ? Colors.black54 : greenColor) : Colors.grey.shade200,
    //                       borderRadius: BorderRadius.circular(2),
    //                     ),
    //                     child: Text(day.toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isSelectable && selectedDates.contains(itemDate) ? Colors.white : Colors.grey.shade700, fontSize: 14.0, fontWeight: FontWeight.w400)),
    //                   ),
    //                 ),
    //               );
    //             },
    //             itemCount: 7 * 6,
    //           )),
    //     )
    //   ],
    // );

    return SfDateRangePicker(
      initialSelectedDates: selectedDates,
      initialSelectedDate: DateTime.now(),
      showNavigationArrow: true,
      minDate: DateTime.now().subtract(Duration(days: 1)),
      navigationMode: DateRangePickerNavigationMode.snap,
      selectionMode: DateRangePickerSelectionMode.multiple,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        blackoutDates: widget.isEditable ? [] : selectedDates,
      ),
      selectionColor: greenColor,
      selectionShape: DateRangePickerSelectionShape.rectangle,
      headerStyle: const DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color: Color(0xFF000000),
        ),
      ),
      rangeTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        setState(() {
            selectedDates = args.value;
            widget.onDatesChanged(selectedDates.map((e) => DateFormat('dd/MM/yyyy').format(e)).toList());
        });
      },
    
      monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(
                 fontWeight: FontWeight.w500,
                 fontSize: 18,
                 color: Colors.white,
        ),
        blackoutDatesDecoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.circular(2),
        ),

      ),
    );
  }

  // void _handlePan(Offset localPosition) {
  //   double width = MediaQuery.of(context).size.width / 7;
  //   double height = width; // Assuming squares for simplicity.

  //   int column = (localPosition.dx / width).floor();
  //   int row = (localPosition.dy / height).floor();

  //   int index = row * 7 + column;
  //   final day = index - (selectedDate.weekday - 1) + 1;

  //   if (day > 0 && day <= daysInMonth(selectedDate)) {
  //     final itemDate = DateTime(selectedDate.year, selectedDate.month, day);
  //     final isSelectable = itemDate.isAfter(currentDate.subtract(Duration(days: 1)));

  //     if (isSelectable) {
  //       setState(() {
  //         _toggleDate(itemDate);
  //       });
  //     }
  //   }
  // }

  // int daysInMonth(DateTime date) {
  //   final nextMonth = (date.month < 12) ? DateTime(date.year, date.month + 1, 1) : DateTime(date.year + 1, 1, 1);
  //   return nextMonth.subtract(Duration(days: 1)).day;
  // }
}
