import 'package:chat_ui/app/core/utils/common_functions.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.isActive,
    required this.label,
    required this.leftColorActive,
    required this.rightColorActive,
    required this.size,
    required this.isLeftRoundedRectangle,
    required this.isRightRoundedRectangle,
    required this.maxWidth,
    required this.icon,
  });

  final double maxWidth;
  final bool isActive;
  final bool leftColorActive;
  final bool rightColorActive;
  final bool isLeftRoundedRectangle;
  final bool isRightRoundedRectangle;
  final String label;
  final double size;
  final String icon;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    bool isDesktopScreen = maxWidth >= 500;
    final double widths = size / 8.0;
    return Container(
      alignment: Alignment.center,
      height: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: widths,
                    height: 6,
                    decoration: ShapeDecoration(
                      color: leftColorActive ? themeProvider.colorScheme?.primary : themeProvider.colorScheme?.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: isLeftRoundedRectangle
                            ? const BorderRadius.horizontal(
                                left: Radius.circular(20),
                              )
                            : BorderRadius.zero,
                      ),
                    ),
                  ),
                  Container(
                    width: widths,
                    height: 6,
                    decoration: ShapeDecoration(
                      color: rightColorActive ? themeProvider.colorScheme?.primary : themeProvider.colorScheme?.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: isRightRoundedRectangle
                            ? const BorderRadius.horizontal(
                                right: Radius.circular(20),
                              )
                            : BorderRadius.zero,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                child: Container(
                  width: isDesktopScreen   ? 34 : 30,
                  height: isDesktopScreen ? 34 : 30,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: themeProvider.colorScheme!.background, width: 2),
                    color: leftColorActive ? themeProvider.colorScheme?.primary : themeProvider.colorScheme?.primaryContainer,
                  ),
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      leftColorActive ? themeProvider.colorScheme!.background : themeProvider.colorScheme!.secondary.withOpacity(0.4),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size / 4.0,
            child: Text(
              CommonFunctions().convertToTitleCase(label),
              textAlign: TextAlign.center,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: themeProvider.bodyMedium?.copyWith(
                color: leftColorActive ? themeProvider.colorScheme!.primary : themeProvider.colorScheme!.secondary,
                fontSize: isDesktopScreen ? 14 : 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
