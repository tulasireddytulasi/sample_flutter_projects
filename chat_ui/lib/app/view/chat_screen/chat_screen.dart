import 'dart:convert';

import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/core/utils/dummy_data/users_list_data.dart';
import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/model/messages_model.dart';
import 'package:chat_ui/app/provider/movies_provider.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:chat_ui/app/view/chat_screen/widget/custom_text_widget.dart';
import 'package:chat_ui/app/view/chat_screen/widget/text_Image_widget.dart';
import 'package:chat_ui/app/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.maxWidth, required this.title, required this.subTitle});

  final double maxWidth;
  final String title;
  final String subTitle;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String keyButtonContinue = "create_button_continue";
  late ThemeProvider themeProvider;
  int customWidget = 1;
  late UserMessagesModel userMessagesModel;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    userMessagesModel = userMessagesModelFromJson(json.encode(UserDummyData.couplesMessages));
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopScreen = widget.maxWidth >= 652;
    return Consumer<MoviesProvider>(builder: (context, moviesProvider, child) {
      return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        constraints: const BoxConstraints(minHeight: 600),
        decoration: BoxDecoration(
          color: ColorPalette.primary,
          borderRadius: isDesktopScreen ? const BorderRadius.all(Radius.circular(14)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleWidget(
              isDesktopScreen: isDesktopScreen,
              title: widget.title,
              subTitle: widget.subTitle,
            ),
            Divider(color: ColorPalette.blackPrimaryColor.shade100.withOpacity(0.4)),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: userMessagesModel.messages?.length ?? 0,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 14);
                },
                itemBuilder: (context, index) {
                  if ((userMessagesModel.messages?[index].type ?? "") == Types.text.name) {
                    return ChatTextWidget(
                      isUser: userMessagesModel.messages?[index].isUser ?? false,
                      text: userMessagesModel.messages?[index].messageText ?? "",
                    );
                  } else if ((userMessagesModel.messages?[index].type ?? "") == Types.imageText.name) {
                    return ImageTextWidget(
                      isUser: userMessagesModel.messages?[index].isUser ?? false,
                      text: userMessagesModel.messages?[index].messageText ?? "",
                      image: userMessagesModel.messages?[index].file ?? "",
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
    });
  }
}
