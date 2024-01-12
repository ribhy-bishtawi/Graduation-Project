import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class CustomSlidingUpPanel extends StatelessWidget {
  final double controlHeight;
  final double anchor;
  final double minimumBound;
  final double upperBound;
  final SlidingUpPanelController panelController;
  final Widget child;

  const CustomSlidingUpPanel({
    Key? key,
    required this.controlHeight,
    required this.anchor,
    required this.minimumBound,
    required this.upperBound,
    required this.panelController,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanelWidget(
      panelStatus: SlidingUpPanelStatus.hidden,
      onStatusChanged: (status) {
        if (status == SlidingUpPanelStatus.collapsed) {
          panelController.hide();
        }
      },
      controlHeight: controlHeight,
      anchor: anchor,
      minimumBound: minimumBound,
      upperBound: upperBound,
      panelController: panelController,
      onTap: () {},
      enableOnTap: true,
      child: child,
    );
  }
}
