// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../platform_helper/platform_helper.dart';
import '../../providers/interface/attachments.dart';
import '../../styles/llm_chat_view_style.dart';
import '../action_button.dart';

/// A widget that provides an action bar for attaching files or images.
@immutable
class AttachmentActionBar extends StatefulWidget {
  /// Creates an [AttachmentActionBar].
  ///
  /// The [onAttachments] parameter is required and is called when attachments
  /// are selected.
  const AttachmentActionBar({required this.onAttachments, super.key});

  /// Callback function that is called when attachments are selected.
  ///
  /// The selected [Attachment]s are passed as an argument to this function.
  final Function(Iterable<Attachment> attachments) onAttachments;

  @override
  State<AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<AttachmentActionBar> {
  late final bool _canCamera;

  @override
  void initState() {
    super.initState();
    _canCamera = canTakePhoto();
  }

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
    builder: (context, viewModel, child) {
      final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
      // Build a horizontal row of action buttons instead of a popup menu.
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              onPressed: _onGallery,
              style: chatStyle.galleryButtonStyle!,
            ),
            if (_canCamera) ...[
              ActionButton(
                onPressed: _onCamera,
                style: chatStyle.cameraButtonStyle!,
              ),
            ],
            //This is unabled for now
            if (false)
              ActionButton(
                onPressed: _onFile,
                style: chatStyle.attachFileButtonStyle!,
              ),
          ],
        ),
      );
    },
  );

  void _onCamera() => unawaited(_pickImage(ImageSource.camera));
  void _onGallery() => unawaited(_pickImage(ImageSource.gallery));

  Future<void> _pickImage(ImageSource source) async {
    assert(
      source == ImageSource.camera || source == ImageSource.gallery,
      'Unsupported image source: $source',
    );

    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final pics = await picker.pickMultiImage();
        final attachments = await Future.wait(
          pics.map(ImageFileAttachment.fromFile),
        );
        widget.onAttachments(attachments);
      } else {
        final pic = await takePhoto(context);
        if (pic == null) return;
        widget.onAttachments([await ImageFileAttachment.fromFile(pic)]);
      }
    } on Exception catch (ex) {
      if (context.mounted) {
        // I just checked this! ^^^
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick an image: $ex');
      }
    }
  }

  Future<void> _onFile() async {
    try {
      final files = await openFiles();
      final attachments = await Future.wait(files.map(FileAttachment.fromFile));
      widget.onAttachments(attachments);
    } on Exception catch (ex) {
      if (context.mounted) {
        // I just checked this! ^^^
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick a file: $ex');
      }
    }
  }
}
