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

    super.key,
  }) : super(listenable: animation);

  /// The font size of the dot.
  final double iconSize;

  /// The asset path of the .
  final String svgAsset;

  /// Optional package name when the asset is bundled inside a package.
  final String? packageName;

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: iconSize,
    child: Transform.rotate(
      angle: _animation.value * 2 * 3.1416, // Full rotation per animation cycle
      child: SvgPicture.asset(
        svgAsset,
        package: packageName,
        width: iconSize,
        height: iconSize,
      ),
    ),
  );
}
