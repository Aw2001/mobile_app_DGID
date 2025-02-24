import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String fieldKey;
  final String? labelText;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final bool readOnly;
  final bool isNumber;
  final bool isMultiline;
  final bool isDate;
  final List<String>? dropdownItems;
  final String? initialValue;
  final Function(DateTime?)? onDateSelected;

  InputField({
    required this.fieldKey,
    required this.labelText,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.isNumber = false,
    this.isMultiline = false,
    this.isDate = false,
    this.dropdownItems,
    this.initialValue,
    this.onDateSelected, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (dropdownItems != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          value: initialValue,
          hint: Text(labelText!),
          items: dropdownItems!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 255, 254, 251),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFFC3AD65)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      );
    } else if (isDate) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          readOnly: true,
          cursorColor: Color(0xFFC3AD65),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 255, 254, 251),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFFC3AD65)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: labelText,
            floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
            labelStyle: TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              controller?.text = formattedDate;
              onDateSelected?.call(pickedDate);
            }
          },
        ),
      );
    } else if (isNumber) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          cursorColor: const Color(0xFFC3AD65),
          keyboardType: TextInputType.number, // Clavier numérique
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Permet uniquement les chiffres
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 254, 251),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFFC3AD65)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: labelText,
            floatingLabelStyle: const TextStyle(color: Color(0xFFC3AD65)),
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    } else if (isMultiline) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          maxLines: null,
          controller: controller,
          cursorColor: Color(0xFFC3AD65),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 255, 254, 251),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFFC3AD65)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: labelText,
            floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          cursorColor: Color(0xFFC3AD65),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 255, 254, 251),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFFC3AD65)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: labelText,
            floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
