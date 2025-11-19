// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart'
    show CircularProgressIndicator, IconButton;
import 'package:flutter/widgets.dart';

import '../utility.dart';

/// A progress indicator that adapts to the current platform.
///
@immutable
class AdaptiveCircularProgressIndicator extends StatelessWidget {
  /// Creates an adaptive circular progress indicator.
  ///
  /// This widget will display a [CupertinoActivityIndicator] on iOS
  /// and a [CircularProgressIndicator] on other platforms.
  ///
  /// The [key] parameter is optional and is used to control how one widget
  /// replaces another widget in the tree.
  const AdaptiveCircularProgressIndicator({required this.color, super.key});

  /// The color of the progress indicator.
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Build a 24×24 constrained indicator for both platforms.
    final Widget indicator =
        isCupertinoApp(context)
            ? SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: CupertinoActivityIndicator(color: color, radius: 12),
              ),
            )
            : SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: color, strokeWidth: 2),
            );

    // Place the indicator inside a disabled IconButton (onPressed: null) so it
    // appears as an icon within the usual icon touch target but is disabled.
    return IconButton(onPressed: null, icon: indicator, tooltip: null);
  }
}
