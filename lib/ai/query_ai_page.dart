import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/ai/ai_providers.dart';
import 'package:sample_pwa/ai/data/ai_models.dart';
import 'package:sample_pwa/common_widgets/message_view.dart';

class QueryAiPage extends HookConsumerWidget {
  final queryController = TextEditingController();

  QueryAiPage({super.key});

  final responseList = List<PromptResponse>.empty(growable: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final queryPrompt = useState('');

    return Scaffold(
      body: ref.watch(generateContentStreamProvider(queryPrompt.value)).when(
        data: (value) {
          print('Value - ${value}');
          if (value.promptResult.isNotEmpty) {
            final index =
                responseList.indexWhere((e) => e.millis == value.millis);
            if (index != -1) {
              responseList[index] = value;
            } else {
              responseList.add(value);
            }
          }

          return ListView.builder(
            itemCount: responseList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: TextFormField(
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(hintText: 'Enter your query'),
                        controller: queryController,
                        validator: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return 'Please type something';
                          }
                          return null;
                        },
                      ),
                      trailing: IconButton(
                          onPressed: loading.value
                              ? null
                              : () async {
                                  queryPrompt.value = queryController.text;
                                },
                          icon: loading.value
                              ? const Icon(Icons.downloading)
                              : const Icon(Icons.check_circle)),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                );
              }
              final item = responseList[index - 1];
              return Card(
                  child: ListTile(
                      title: MarkdownBody(
                data: item.promptResult,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(fontSize: 14),
                ),
              )));
            },
          );
        },
        error: (obj, objectTrace) {
          return MessageView(message: objectTrace.toString());
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
