// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// this file forked from https://github.com/wal33d006/progress_indicators due to
// lack of activity

import 'package:flutter/widgets.dart';

import 'rotating_svg.dart';

/// Creates a list with [numberOfElements] text dots, with 3 dots as default
/// default [iconsSize] of 10.0, default [color] as black, [starsSpacing] (gap
/// between each dot) as 0.0 and default time for one cycle of animation
/// [milliseconds] as 250.
/// One cycle of animation is one complete round of a dot animating up and back
/// to its original position.
@immutable
class RotatingSvgProgressIndicator extends StatefulWidget {
  /// Creates a jumping dot progress indicator.
  const RotatingSvgProgressIndicator({
    required this.svgAsset,
    super.key,
    this.numberOfElements = 2,
    this.iconsSize = const [24.0, 12.0],
    this.starsSpacing = 8.0,
    this.milliseconds = 250,
    this.packageName,
  });

  /// Number of dots that are added in a horizontal list, default = 3.
  final int numberOfElements;

  /// Font size of each dot, default = 10.0.
  /// This is a list where each element corresponds to the size of each svg.
  final List<double> iconsSize;

  /// Spacing between each dot, default 0.0.
  final double starsSpacing;

  /// Time of one complete cycle of animation, default 250 milliseconds.
  final int milliseconds;

  /// The svg asset to be used.
  final String svgAsset;

  /// Optional package name when the asset is bundled inside a package.
  final String? packageName;

  @override
  State<RotatingSvgProgressIndicator> createState() =>
      _RotatingSvgProgressIndicatorState();
}

class _RotatingSvgProgressIndicatorState
    extends State<RotatingSvgProgressIndicator>
    with TickerProviderStateMixin {
  final _controllers = <AnimationController>[];
  final _animations = <Animation<double>>[];
  final _widgets = <Widget>[];
  static const double _beginTweenValue = 0;
  static const double _endTweenValue = 8;

  double _getIconSize(int index) {
    if (index < widget.iconsSize.length) return widget.iconsSize[index];
    if (widget.iconsSize.isNotEmpty) return widget.iconsSize.first;
    return 24.0; // fallback
  }

  @override
  void initState() {
    super.initState();

    // for each dot...
    for (var svgIndex = 0; svgIndex < widget.numberOfElements; svgIndex++) {
      // add an animation controller for the dot
      _controllers.add(
        AnimationController(
          duration: Duration(milliseconds: widget.milliseconds),
          vsync: this,
        ),
      );

      // build an animation for the dot using the controller
      _animations.add(
        Tween(begin: _beginTweenValue, end: _endTweenValue).animate(
          _controllers[svgIndex],
        )..addStatusListener((status) => _dotListener(status, svgIndex)),
      );

      // add a dot widget with that animation
      _widgets.add(
        Padding(
          padding: EdgeInsets.only(right: widget.starsSpacing),
          child: RotatingSvg(
            animation: _animations[svgIndex],
            iconSize: _getIconSize(svgIndex),
            svgAsset: widget.svgAsset,
            packageName: widget.packageName,
          ),
        ),
      );
    }

    // start the animation
    if (_controllers.isNotEmpty) _controllers[0].forward();
  }

  void _dotListener(AnimationStatus status, int dot) {
    if (status == AnimationStatus.completed) {
      _controllers[dot].reverse();
    }

    if (dot == widget.numberOfElements - 1 &&
        status == AnimationStatus.dismissed) {
      _controllers[0].forward();
    }

    if (_animations[dot].value > _endTweenValue / 2 &&
        dot < widget.numberOfElements - 1) {
      _controllers[dot + 1].forward();
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _getIconSize(0) + (_getIconSize(0) * 0.5),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: _widgets),
  );

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }

    super.dispose();
  }
}
