import 'package:chat_ui/app/provider/movies_provider.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:chat_ui/app/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CelebritiesScreen extends StatefulWidget {
  const CelebritiesScreen({super.key, required this.maxWidth});

  final double maxWidth;

  @override
  State<CelebritiesScreen> createState() => _CelebritiesScreenState();
}

class _CelebritiesScreenState extends State<CelebritiesScreen> {
  final String keyButtonContinue = "celeb_button_continue";
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
    return Consumer<MoviesProvider>(builder: (context, MoviesProvider, child) {
      return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(minHeight: 500),
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
              title: "Celebrities",
              subTitle: "Popular Celebrities",
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
