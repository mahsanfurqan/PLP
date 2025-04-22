import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 8) text = text.substring(0, 8);

    var newText = '';
    for (int i = 0; i < text.length; i++) {
      newText += text[i];
      if ((i == 1 || i == 3) && i != text.length - 1) {
        newText += '/';
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(':', '');
    if (text.length > 4) text = text.substring(0, 4);

    var newText = '';
    for (int i = 0; i < text.length; i++) {
      newText += text[i];
      if (i == 1 && i != text.length - 1) {
        newText += ':';
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
