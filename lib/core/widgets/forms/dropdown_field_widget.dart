import 'package:flutter/material.dart';

import '../../../config/locale/app_localization_helper.dart';
import '../../utils/app_colors.dart';
import '../../validation/app_form_validator.dart';

class DropdownFieldWidget<T> extends StatefulWidget {
  final String hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? errorStyle;
  final double borderWidth;
  final Color borderColor;
  final Color errorBorderColor;
  final String validateType;
  final FormFieldSetter onSave;
  final List<T> items;
  final TextStyle? itemTextStyle;
  final TextStyle? selectedItemTextStyle;

  const DropdownFieldWidget({
    Key? key,
    required this.hintText,
    required this.hintTextStyle,
    required this.errorStyle,
    required this.errorBorderColor,
    required this.borderWidth,
    required this.borderColor,
    required this.validateType,
    required this.onSave,
    required this.items,
    required this.itemTextStyle,
    required this.selectedItemTextStyle,
  }) : super(key: key);

  @override
  State<DropdownFieldWidget<T>> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState<T> extends State<DropdownFieldWidget<T>> {
  String validation = "";
  T? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      decoration: _buildEnabledDecoration(),
      hint: Text(
        widget.hintText,
        style: widget.hintTextStyle,
      ),
      value: selectedValue,
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: selectedValue == item.toString()
                      ? widget.selectedItemTextStyle
                      : widget.itemTextStyle,
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
          validation =
              AppFormValidator.validate(value.toString(), widget.validateType)!;
        });
      },
      validator: (value) {
        return validation == ""
            ? null
            : AppLocalizationHelper.translate(context, validation);
      },
      onSaved: (value) {
        widget.onSave(value);
      },
    );
  }

  InputDecoration _buildEnabledDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: widget.hintTextStyle,
      floatingLabelStyle: TextStyle(color: AppColors.fontPrimary),
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
}
