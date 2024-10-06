import 'package:chat_ui/app/core/utils/constants.dart';
import 'package:chat_ui/app/core/utils/screen_sizes.dart';
import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key, required this.label, required this.maxWidth, required this.onChanged});
  final String label;
  final double maxWidth;
  final Function(bool?) onChanged;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  final ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    bool isDesktopScreen = isDesktop(screenWidth: widget.maxWidth);
    return ValueListenableBuilder<bool>(
        valueListenable: isChecked,
        builder: (context, isValid, _) {
        return Row(
          children: [
            Checkbox(
              value: isChecked.value,
              activeColor: Theme.of(context).disabledColor,
              checkColor: Theme.of(context).colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Adjust density
              onChanged: (bool? value) {
                isChecked.value = value!;
                widget.onChanged(value);
              },
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isDesktopScreen ? 14 : 12,
                    fontFamily: isDesktopScreen ? Constants.montserratRegular : Constants.montserratMedium,
                  ),
            ),
          ],
        );
      }
    );
  }
}