import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/provider/movies_provider.dart';
import 'package:chat_ui/app/view/home_screen/widget/main_container_widget.dart';
import 'package:chat_ui/app/view/userslist_screen/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/screen_sizes.dart';
import 'package:chat_ui/app/widget/app_icon_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.subScreen, required this.mainScreen});

  final MAIN_SCREENS mainScreen;
  final SUB_SCREENS subScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MoviesProvider moviesProvider;

  @override
  void initState() {
    super.initState();
    moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.clearAllData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktopScreen = isDesktop(screenWidth: constraints.maxWidth);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorPalette.whitePrimaryColor.shade100,
          appBar: isDesktopScreen
              ? null
          // const PreferredSize(
          //         preferredSize: Size.fromHeight(70.0),
          //         child: DesktopAppBar(),
          //       )
              : AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  actions: const [],
                  elevation: 0,
                  title: const Padding(
                    padding: EdgeInsets.all(20),
                    child: AppIconWidget(),
                  ),
                  centerTitle: true,
                ),
          extendBody: true,
          extendBodyBehindAppBar: true,
          drawer: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            width: constraints.maxWidth - 80,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 40, left: 14),
          child: UsersListScreen(
            maxWidth: (constraints.maxWidth - 80),
            mainScreens: widget.mainScreen,
            subScreen: widget.subScreen,
            isMobileScreen: true,
          ),
        ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: getCardWidth(screenWidth: constraints.maxWidth),
                      margin: isDesktopScreen ? const EdgeInsets.only(left: 20, right: 20, bottom: 20) : null,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return isDesktopScreen
                              ? Card(
                                  elevation: 0,
                                  color: ColorPalette.whitePrimaryColor.shade100,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: MainContainer(
                                    maxWidthAndHeight: constraints,
                                    mainScreen: widget.mainScreen,
                                    subScreen: widget.subScreen,
                                  ),
                                )
                              : MainContainer(
                                  maxWidthAndHeight: constraints,
                                  mainScreen: widget.mainScreen,
                                  subScreen: widget.subScreen,
                                );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
