import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomRadio extends StatelessWidget {
  final String groupValue, value;
  final Function(String?) onChanged;
  const CustomRadio(
      {Key? key,
      required this.groupValue,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: (){
            onChanged(value);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Radio<String>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: (str) {
                    onChanged(str);
                  },
                  activeColor: themeProvider.colorScheme!.primary,
                  splashRadius: 0,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                value,
                style: themeProvider.bodySmall?.copyWith(
                  fontSize: 16,
                  color: value == groupValue ? themeProvider.colorScheme!.primary : themeProvider.colorScheme!.secondary,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
