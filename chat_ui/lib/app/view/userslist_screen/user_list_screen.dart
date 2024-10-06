import 'dart:convert';
import 'dart:developer';

import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/common_functions.dart';
import 'package:chat_ui/app/core/utils/constants.dart';
import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/core/utils/screen_sizes.dart';
import 'package:chat_ui/app/model/user_list_model.dart';
import 'package:chat_ui/app/provider/menu_provider.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:chat_ui/app/view/userslist_screen/widget/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({
    super.key,
    required this.maxWidth,
    required this.mainScreens,
    required this.subScreen,
    this.isMobileScreen = false,
  });
  final double maxWidth;
  final MAIN_SCREENS mainScreens;
  final SUB_SCREENS subScreen;
  final bool isMobileScreen;

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> with TickerProviderStateMixin {
  late MenuProvider menuProvider;
  late UserListModel userListModel;

  @override
  void initState() {
    super.initState();
    menuProvider = Provider.of<MenuProvider>(context, listen: false);
    fetchUsersLis();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expandMenu();
    });
  }

  fetchUsersLis() {
    userListModel = userListModelFromJson(json.encode(menuProvider.menuList));
  }

  expandMenu() {
    int index = 0;
    if (widget.mainScreens == MAIN_SCREENS.movies) {
      index = 0;
    } else if (widget.mainScreens == MAIN_SCREENS.tvSeries) {
      index = 1;
    } else if (widget.mainScreens == MAIN_SCREENS.celebrities) {
      index = 2;
    }
    menuProvider.setSelectedMenuIndex = index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    bool isDesktopScreen = isDesktop(screenWidth: widget.maxWidth);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Movies",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: Constants.montserratSemiBold,
                    color: ColorPalette.whitePrimaryColor,
                    fontSize: 14,
                  ),
            ),
            Visibility(
              visible: !isDesktopScreen,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    Assets.closeIcon,
                    fit: BoxFit.contain,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Consumer<MenuProvider>(builder: (context, menuProvider, child) {
          return Expanded(
            child: ListView.builder(
              itemCount: userListModel.usersList?.length ?? 0,
              shrinkWrap: true,
              physics:  const BouncingScrollPhysics(),
              itemBuilder: (context, index)
              {
                UsersList? usersList = userListModel.usersList?[index];
                final String icon = usersList?.icon ?? "";
                final String name = usersList?.name ?? "";
                String mainScreen = usersList?.mainRoutes ?? "";
                bool isSelectedItem = menuProvider.selectedMenuIndex == index;
                if(userListModel.usersList!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "No Users List...",
                      style: themeProvider.titleMedium!.copyWith(
                        color: ColorPalette.whitePrimaryColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          log("Main URL: $mainScreen");
                          CommonFunctions().clearALLData(context: context);
                          GoRouter.of(context).go(mainScreen);
                          menuProvider.setSelectedMenuIndex = index;
                        },
                        child: UserItem(
                          name: name,
                          isSelectedItem: isSelectedItem,
                          icon: icon,
                          textStyle: themeProvider.titleMedium!,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }
              },
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}
