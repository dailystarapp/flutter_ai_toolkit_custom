// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

/// A widget that represents a single jumping dot in the progress indicator.
@immutable
class RotatingSvg extends AnimatedWidget {
  /// Creates a [RotatingSvg] widget.
  ///
  /// The [animation] parameter is required and controls the vertical movement
  /// of the svg. The
  /// [iconSize] parameter determines the size of the svg.
  const RotatingSvg({
    required Animation<double> animation,
    required this.iconSize,
    required this.svgAsset,
    this.packageName,
    this.valueRange = 1.0,

    super.key,
  }) : super(listenable: animation);

  /// The font size of the dot.
  final double iconSize;

  /// The asset path of the .
  final String svgAsset;

  /// Optional package name when the asset is bundled inside a package.
  final String? packageName;

  /// The numeric range of the animation values (animation runs from 0 to
  /// [valueRange]). This is used to normalize the animation value to [0..1]
  /// when computing rotation so the widget rotates a single full turn per
  /// animation cycle by default.
  final double valueRange;

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    // Normalize the animation value into 0..1 before converting to radians.
    final normalized =
        valueRange > 0 ? (_animation.value / valueRange) : _animation.value;
    final angle = (normalized.clamp(0.0, 1.0)) * 2 * 3.141592653589793;

    return SizedBox(
      height: iconSize,
      child: Transform.rotate(
        angle: angle, // Full rotation per animation cycle (normalized)
        child: SvgPicture.asset(
          svgAsset,
          package: packageName,
          width: iconSize,
          height: iconSize,
        ),
      ),
    );
  }
}
