import 'package:flutter/material.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../styles/suggestion_style.dart';

/// A widget that displays a list of chat suggestions.
///
/// This widget takes a list of suggestions and a callback function that is
/// triggered when a suggestion is selected. Each suggestion is displayed
/// as a tappable container with padding and a background color.
@immutable
class ChatSuggestionsView extends StatelessWidget {
  /// Creates a [ChatSuggestionsView] widget.
  ///
  /// The [welcomeMessage] parameter is a string that is displayed at the top
  /// of the list of suggestions.
  /// The [suggestions] parameter is a list of suggestion strings to display.
  /// The [onSelectSuggestion] parameter is a callback function that is called
  /// when a suggestion is tapped.
  const ChatSuggestionsView({
    required this.welcomeMessage,
    required this.suggestions,
    required this.onSelectSuggestion,
    super.key,
  });

  /// The message to display at the top of the list of suggestions.
  final String welcomeMessage;

  /// The list of suggestions to display.
  final List<String> suggestions;

  /// The callback function to call when a suggestion is selected.
  final void Function(String suggestion) onSelectSuggestion;

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
    builder: (context, viewModel, child) {
      final suggestionStyle = SuggestionStyle.resolve(
        viewModel.style?.suggestionStyle,
      );
      return Column(
        children: [
          Text(
            welcomeMessage,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          for (final suggestion in suggestions)
            GestureDetector(
              onTap: () => onSelectSuggestion(suggestion),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: suggestionStyle.decoration,
                child: Text(
                  suggestion,
                  softWrap: true,
                  maxLines: 3,
                  style: suggestionStyle.textStyle,
                ),
              ),
            ),
        ],
      );
    },
  );
}
