import 'package:chat_ui/app/core/utils/color_palette.dart';
import 'package:chat_ui/app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatefulWidget {
  const UserItem({
    super.key,
    required this.name,
    required this.isSelectedItem,
    required this.icon,
    this.margin = EdgeInsets.zero,
    required this.textStyle,
    this.animation,
  });

  final String icon;
  final String name;
  final bool isSelectedItem;
  final EdgeInsetsGeometry margin;
  final TextStyle textStyle;
  final Animation<double>? animation;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          margin: widget.margin,
          decoration: widget.isSelectedItem
              ? ShapeDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-1, 0),
                    end: const Alignment(1.00, -0.00),
                    colors: [
                      ColorPalette.primary,
                      ColorPalette.primary.withOpacity(0),
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: widget.icon.isNotEmpty,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.icon),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Visibility(
                visible: widget.icon.isNotEmpty,
                child: const SizedBox(width: 6),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: widget.textStyle.copyWith(
                      color: widget.isSelectedItem ? ColorPalette.whitePrimaryColor : ColorPalette.whitePrimaryColor.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                   width: constraints.maxWidth - 130,
                    child: Text(
                      "Thank you for choosing Rare Rabbit🙂",
                    maxLines: 1,
                      softWrap: true,
                      style: widget.textStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: widget.isSelectedItem ? ColorPalette.whitePrimaryColor : ColorPalette.whitePrimaryColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.icon.isNotEmpty,
                child: const Spacer(),
              ),
              Visibility(
                visible: widget.icon.isNotEmpty,
                child: RotationTransition(
                  turns: widget.animation == null ? const AlwaysStoppedAnimation(0.0) : widget.animation!,
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: ColorPalette.whitePrimaryColor.withOpacity(0.4),
                  ),
                ),
              ),
              Visibility(visible: widget.icon.isNotEmpty, child: const SizedBox(width: 6)),
            ],
          ),
        );
      }
    );
  }
}
