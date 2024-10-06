import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/core/utils/screen_sizes.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:chat_ui/app/view/chat_screen/chat_screen.dart';
import 'package:chat_ui/app/view/userslist_screen/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({
    super.key,
    required this.mainScreen,
    required this.subScreen,
    required this.maxWidthAndHeight,
  });

  final BoxConstraints maxWidthAndHeight;
  final MAIN_SCREENS mainScreen;
  final SUB_SCREENS subScreen;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

int getUsersListScreenSize(maxSize){
  int size = 3;
  if(maxSize <= 800){
    size = 4;
  } if(maxSize <= 600){
    size = 5;
  }
  return size;
}

int getChatScreenSize(maxSize){
  int size = 7;
  if(maxSize <= 800){
    size = 6;
  } if(maxSize <= 600){
    size = 5;
  }
  return size;
}

class _MainContainerState extends State<MainContainer> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final double maxWidth = widget.maxWidthAndHeight.maxWidth;
    bool isDesktopScreen = isDesktop(screenWidth: maxWidth);
    return Container(
      width: maxWidth,
      alignment: Alignment.topCenter,
      height: widget.maxWidthAndHeight.maxHeight,
      padding: EdgeInsets.all(isDesktopScreen ? 6 : 0),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: ColorPalette.primaryContainer,
        borderRadius: isDesktopScreen ? const BorderRadius.all(Radius.circular(20)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: getUsersListScreenSize(maxWidth),
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 20, left: 14),
              child: UsersListScreen(
                maxWidth: widget.maxWidthAndHeight.maxWidth,
                mainScreens: widget.mainScreen,
                subScreen: widget.subScreen,
              ),
            ),
          ),
          Visibility(
            visible: maxWidth >= 450,
            child: Expanded(
              flex: getChatScreenSize(maxWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ChatScreen(
                    maxWidth: maxWidth,
                    title: "Tulasi Reddy",
                    subTitle: "Online",
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
