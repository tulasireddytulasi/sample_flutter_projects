import 'package:expense_tracker/core/utils/app_styles.dart';
import 'package:expense_tracker/core/utils/color_palette.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.category,
  });

  final String title;
  final String amount;
  final String dateTime;
  final String category;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      color: ColorPalette.secondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, color: ColorPalette.primary, size: 32),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width/2,
                  child: Text(
                    title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppStyles.mediumTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  category,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.mediumTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dateTime,
                      style: AppStyles.mediumTextStyle,
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_upward_rounded),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 4),
                  child: Text(
                    amount,
                    style: AppStyles.mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
