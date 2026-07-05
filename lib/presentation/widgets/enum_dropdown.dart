import 'package:flutter/material.dart';

class EnumDropdown<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) displayName;

  final String? hintText;
  final String? labelText;
  final FormFieldValidator<T>? validator;

  const EnumDropdown({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.displayName,
    this.hintText,
    this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: selectedValue,
      validator: validator,
      decoration: InputDecoration(labelText: labelText),
      hint: hintText != null ? Text(hintText!) : null,
      items: values.map((value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(displayName(value)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
