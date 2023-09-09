import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../validation/text_field_validation.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final double borderWidth;
  final Color borderColor;
  final Color errorBorderColor;
  final bool secureText;
  final String validateType;
  final TextInputType keyboardType;
  final FormFieldSetter onSave;
  final TextAlign textAlign;

  const TextFieldWidget(
      {Key? key,
      required this.label,
      required this.labelStyle,
      required this.errorStyle,
      required this.borderWidth,
      required this.borderColor,
      required this.errorBorderColor,
      required this.secureText,
      required this.validateType,
      required this.keyboardType,
      required this.onSave,
      required this.textAlign})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String validation = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: widget.secureText,
      obscuringCharacter: "*",
      autocorrect: false,
      textAlign: widget.textAlign,
      enableSuggestions: false,
      style: widget.labelStyle,
      onSaved: widget.onSave,
      decoration: InputDecoration(
          labelText: widget.label,
          floatingLabelStyle: TextStyle(color: AppColors.fontPrimary),
          contentPadding: const EdgeInsets.only(left: 22, right: 22),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: widget.errorBorderColor,
              width: widget.borderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: widget.errorBorderColor,
              width: widget.borderWidth,
            ),
          ),
          errorStyle: widget.errorStyle),
      onChanged: (value) {
        validation = ValidateTextFiled.validate(value, widget.validateType)!;
      },
      validator: (value) {
        return validation == "" ? null : AppLocalizations.of(context)!.translate(validation)!;
      },
    );
  }
}
