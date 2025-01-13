import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StartEndDatePickerSection extends StatefulWidget {
  final Function(DateTime?, DateTime?)? onDateChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const StartEndDatePickerSection({
    super.key,
    this.onDateChanged,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<StartEndDatePickerSection> createState() =>
      _StartEndDatePickerSectionState();
}

class _StartEndDatePickerSectionState extends State<StartEndDatePickerSection> {
  late DateTime? _startSelectedDate;
  late DateTime? _endSelectedDate;
  late TextEditingController _dateRangeController;

  @override
  void initState() {
    super.initState();
    _startSelectedDate = widget.initialStartDate;
    _endSelectedDate = widget.initialEndDate;

    _dateRangeController = TextEditingController(
      text: _startSelectedDate != null && _endSelectedDate != null
          ? '${_startSelectedDate!.day}/${_startSelectedDate!.month}/${_startSelectedDate!.year} - ${_endSelectedDate!.day}/${_endSelectedDate!.month}/${_endSelectedDate!.year}'
          : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 12,
          child: TextField(
            controller: _dateRangeController,
            onTap: () async {
              final selectedRange = await _selectDateRange(context);
              if (selectedRange != null) {
                setState(() {
                  _startSelectedDate = selectedRange.start;
                  _endSelectedDate = selectedRange.end;
                  _dateRangeController.text =
                      '${selectedRange.start.day}/${selectedRange.start.month}/${selectedRange.start.year} - ${selectedRange.end.day}/${selectedRange.end.month}/${selectedRange.end.year}';

                  widget.onDateChanged!(_startSelectedDate, _endSelectedDate);
                });
              }
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date Range",
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              suffixIcon: const Icon(FontAwesomeIcons.calendarAlt, size: 20),
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              setState(() {
                _startSelectedDate = null;
                _endSelectedDate = null;
                _dateRangeController.clear();
                widget.onDateChanged!(null, null);
              });
            },
            icon: _dateRangeController.value.text.isNotEmpty
                ? Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
          ),
        ),
      ],
    );
  }

  Future<DateTimeRange?> _selectDateRange(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: _startSelectedDate ?? DateTime.now(),
        end: _endSelectedDate ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.blue)
                .copyWith(secondary: Colors.blue),
          ),
          child: child!,
        );
      },
    );
  }
}
