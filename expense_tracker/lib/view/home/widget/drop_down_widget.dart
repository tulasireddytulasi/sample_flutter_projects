import 'package:expense_tracker/core/utils/color_palette.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    required this.hintText,
    required this.value,
    required this.onChanged,
    required this.listData,
  });

  final String hintText;
  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> listData;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width > 600 ? 600 : width,
      //margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.primary, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton(
        hint: Text(
          widget.hintText,
          style: const TextStyle(color: ColorPalette.black, fontSize: 14),
        ),
        dropdownColor: ColorPalette.white,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 36,
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(color: ColorPalette.primary, fontSize: 22),
        value: widget.value,
        onChanged: widget.onChanged,
        items: widget.listData.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: ColorPalette.black, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }
}
