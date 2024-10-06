import 'package:chat_ui/app/core/utils/assets_path.dart';
import 'package:chat_ui/app/widget/stepper_widget/step_widget.dart';
import 'package:flutter/material.dart';

class StepperWidget extends StatefulWidget {
  const StepperWidget({
    super.key,
    required this.noOfActiveItems,
    required this.steps,
    required this.width,
    required this.maxWidth,
  });

  final int noOfActiveItems;
  final List<String> steps;
  final double width;
  final double maxWidth;

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  late bool leftColorActive;
  late bool rightColorActive;
  String icon = "";
  int noOfActiveItems = 0;

  @override
  void initState() {
    super.initState();
    leftColorActive = false;
    rightColorActive = false;
  }

  @override
  void didUpdateWidget(covariant StepperWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    noOfActiveItems = widget.noOfActiveItems;
  }

  @override
  Widget build(BuildContext context) {
    noOfActiveItems = widget.noOfActiveItems;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(widget.steps.length, (index) {
        /// Decrement the value of [noOfActiveItems] by 1 to account for the fact that
        /// array indices start from 0. This operation reflects the adjustment needed
        if (index == 0) {
          noOfActiveItems = noOfActiveItems - 1;
        }

        /// Ensure that both [leftColorActive] and [rightColorActive] variables are set to true
        /// when the value of [index] is less than [noOfActiveItems].
        /// This condition signifies that the left and right horizontal bars should be displayed
        /// in an active (pink) color, indicating the completion of the specific steps related
        /// to the given index.
        if (index < noOfActiveItems) {
          leftColorActive = true;
          rightColorActive = true;
          icon = Assets.completedIcon;
        }

        /// Ensure that the [leftColorActive] variables are set to true
        /// and [rightColorActive] variables are set to false
        /// when the value of [index] is equal to [noOfActiveItems].
        /// This condition signifies that the left horizontal bars should be displayed in an active (pink) color
        /// and right horizontal bars should be displayed in an deActive (very light pink) color,
        /// indicating the completion of the specific steps related
        /// to the given index.
        else if (index == noOfActiveItems) {
          leftColorActive = true;
          rightColorActive = false;
          icon = Assets.hourGlassIcon;
        }

        /// Ensure that both [leftColorActive] and [rightColorActive] variables are set to false
        /// when all steps are in-process, when the current [index] surpasses the total number of active items,
        /// as denoted by [noOfActiveItems]. This condition signifies that the left and right horizontal bars
        /// should be displayed in an deActive (very light pink) color, indicating the pending of
        /// the specific steps related to the given index.
        else if (index > noOfActiveItems) {
          leftColorActive = false;
          rightColorActive = false;
          icon = Assets.hourGlassIcon;
        }

        /// Ensure that both [leftColorActive] and [rightColorActive] variables are set to true
        /// when all steps are complete. This condition indicates that the left and right
        /// horizontal bars should be displayed in an active (pink) color, reflecting the
        /// completion of the overall process.
        if (widget.steps.length == noOfActiveItems + 1) {
          leftColorActive = true;
          rightColorActive = true;
          icon = Assets.completedIcon;
        }

        return StepItem(
          maxWidth: widget.maxWidth,
          isActive: leftColorActive,
          leftColorActive: leftColorActive,
          isLeftRoundedRectangle: index == 0,
          isRightRoundedRectangle: index == widget.steps.length - 1,
          rightColorActive: rightColorActive,
          label: widget.steps[index],
          size: widget.width,
          icon: icon,
        );
      }),
    );
  }
}
