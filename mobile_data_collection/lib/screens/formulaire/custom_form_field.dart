import 'package:mobile_data_collection/utils/exports.dart';


class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, 
  required this.labelText, 
  required this.controller,
  this.inputFormatters, 
  this.validator,
  this.maxLines,
  this.suffixIcon,
  this.onTap, 
  this.onChange,});

  final String labelText;
  final int? maxLines;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon; // Permet de spécifier l'icône suffixe lors de l'utilisation
  final VoidCallback? onTap; 
  final void Function(String?)? onChange;

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(fontSize: 10),
        maxLines: maxLines,
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validator,
        cursorColor: Color(0xFFC3AD65),
        readOnly: labelText == "region" || labelText == "departement" || labelText == "commune" || labelText == "section",
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 10),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          labelText: labelText,
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 254, 251),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: const BorderSide(color: Color(0xFFC3AD65)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          floatingLabelStyle: const TextStyle(color: Color(0xFFC3AD65), fontSize: 10),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 10),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChange,
        onTap: onTap,
      ),
    );
  }
}