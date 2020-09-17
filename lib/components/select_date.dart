import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate {
  static Future<DateTime> picker(
      BuildContext context, DateTime selectedDate, TextEditingController controller,
      [DateTime firstDate]) async {
    final dateFormat = DateFormat("dd/MM/yyyy");
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2019, 10, 1),
      lastDate: DateTime.now(),
      locale: Locale("pt"),
    );
    if (picked != null && picked != selectedDate) {
      controller.value = TextEditingValue(text: dateFormat.format(picked));
    }
    return picked;
  }
}
