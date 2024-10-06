import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/provider/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:chat_ui/app/widget/title_widget.dart';
import 'package:provider/provider.dart';

class TVSeriesScreen extends StatefulWidget {
  const TVSeriesScreen({super.key, required this.maxWidth, required this.subScreen});

  final double maxWidth;
  final SUB_SCREENS subScreen;

  @override
  State<TVSeriesScreen> createState() => _TVSeriesScreenState();
}

class _TVSeriesScreenState extends State<TVSeriesScreen> {
  final String keyButtonContinue = "tv_button_continue_1";

  late ThemeProvider themeProvider;
  int customWidget = 1;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopScreen = widget.maxWidth >= 652;
    return Consumer<MoviesProvider>(builder: (context, searchProvider, child) {
      return Container(
        alignment: Alignment.topLeft,
        constraints: const BoxConstraints(minHeight: 500),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.colorScheme?.background,
          borderRadius: isDesktopScreen ? const BorderRadius.all(Radius.circular(14)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleWidget(
              isDesktopScreen: isDesktopScreen,
              title: "TV Series",
              subTitle: "Popular TV Series",
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: const Column(
                children: [
                  // MoviesProvider.currentWidget == 1
                  //     ? Widget1(
                  //         maxWidth: widget.maxWidth,
                  //       )
                  //     : const SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
