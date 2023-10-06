import 'package:flutter/material.dart';

import '../../../config/locale/app_localization_helper.dart';
import '../../utils/app_colors.dart';
import '../../validation/app_form_validator.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextStyle? hintTextStyle;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final double borderWidth;
  final Color borderColor;
  final Color errorBorderColor;
  final Color? cursorColor;
  final bool secureText;
  final bool enabled;
  final String validateType;
  final TextInputType keyboardType;
  final FormFieldSetter? onSave;
  final TextAlign textAlign;
  final EdgeInsets contentPadding;
  final ValueChanged<String>? onChange;
  final TextStyle? counterStyle;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.hintTextStyle,
    required this.errorStyle,
    required this.errorBorderColor,
    required this.borderWidth,
    required this.borderColor,
    required this.secureText,
    required this.enabled,
    required this.validateType,
    required this.keyboardType,
    required this.textAlign,
    required this.contentPadding,
    required this.style,
    required this.cursorColor,
    required this.maxLines,
    required this.maxLength,
    this.onSave,
    this.onChange,
    this.counterStyle,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String validation = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      obscureText: widget.secureText,
      obscuringCharacter: "*",
      autocorrect: false,
      textAlign: widget.textAlign,
      enableSuggestions: false,
      style: widget.style,
      maxLength: widget.maxLength,
      onSaved: widget.onSave,
      cursorColor: widget.cursorColor,
      decoration: widget.enabled
          ? _buildEnabledDecoration()
          : _buildDisabledDecoration(),
      onChanged: widget.onChange ??
          (value) {
            setState(() {
              validation =
                  AppFormValidator.validate(value, widget.validateType)!;
            });
          },
      validator: (value) {
        return validation == ""
            ? null
            : AppLocalizationHelper.translate(context, validation);
      },
    );
  }

  InputDecoration _buildEnabledDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: widget.hintTextStyle,
      counterStyle: widget.counterStyle ?? TextStyle(color: AppColors.white),
      floatingLabelStyle: TextStyle(color: AppColors.fontPrimary),
      contentPadding: widget.contentPadding,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide(
          color: widget.errorBorderColor,
          width: widget.borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide(
          color: widget.errorBorderColor,
          width: widget.borderWidth,
        ),
      ),
      errorStyle: widget.errorStyle,
    );
  }

  InputDecoration _buildDisabledDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: widget.hintTextStyle,
      floatingLabelStyle: TextStyle(color: AppColors.fontPrimary),
      contentPadding: widget.contentPadding,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40.0),
        borderSide: BorderSide(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
    );
  }
}
