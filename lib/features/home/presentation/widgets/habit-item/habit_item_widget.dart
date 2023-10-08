import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HabitItemWidget extends StatefulWidget {
  final String title;
  final VoidCallback onPressAction;
  final VoidCallback onPressRemove;
  final Function(String, String) onPressSave;
  final Color? textColor;
  final bool isDone;

  const HabitItemWidget({
    Key? key,
    required this.title,
    required this.onPressAction,
    required this.onPressRemove,
    required this.onPressSave,
    required this.isDone,
    this.textColor,
  }) : super(key: key);

  @override
  State<HabitItemWidget> createState() => _HabitItemWidgetState();
}

class _HabitItemWidgetState extends State<HabitItemWidget> {
  TextEditingController textEditingController = TextEditingController();
  bool isEditing = false;
  late String title;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    textEditingController.text =
        widget.title.substring(0, widget.title.length - 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.grey.withOpacity(0.09),
            ),
            child: Icon(
              LineAwesomeIcons.minus,
              color: AppColors.white.withOpacity(0.9),
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          isEditing
              ? Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLength: 20,
                          controller: textEditingController,
                          style: AppTextStyles.habitNameText,
                          cursorColor: AppColors.fontPrimary,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.fontPrimary),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.fontPrimary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.18,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: Text(
                            widget.title.substring(0, widget.title.length - 5),
                            style: AppTextStyles.habitNameText),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
          isEditing
              ? Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (textEditingController.text.isNotEmpty) {
                          widget.onPressSave(title, textEditingController.text);
                          setState(() {
                            isEditing = false;
                          });
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.grey.withOpacity(0.12),
                        ),
                        child: Icon(LineAwesomeIcons.save,
                            size: 18.0, color: AppColors.green),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        setState(() {
                          textEditingController.text = widget.title
                              .substring(0, widget.title.length - 5);
                          isEditing = false;
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.grey.withOpacity(0.12),
                        ),
                        child: Icon(Icons.restore_outlined,
                            size: 18.0, color: AppColors.grey),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    InkWell(
                      onTap: widget.onPressAction,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.grey.withOpacity(0.12),
                        ),
                        child: Icon(widget.isDone ? Icons.check : Icons.close,
                            size: 18.0,
                            color: widget.isDone
                                ? AppColors.green
                                : AppColors.red),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: widget.onPressRemove,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.grey.withOpacity(0.12),
                        ),
                        child: Icon(Icons.delete_outline,
                            size: 18.0, color: AppColors.grey),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
