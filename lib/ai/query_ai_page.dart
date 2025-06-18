import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/ai/ai_providers.dart';
import 'package:sample_pwa/common_widgets/message_view.dart';

class QueryAiPage extends HookConsumerWidget {
  final queryController = TextEditingController();

  QueryAiPage({super.key});

  var responseList = List<String>.empty(growable: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final queryPrompt = useState('');

    return Scaffold(
      body: ref.watch(generateContentStreamProvider(queryPrompt.value)).when(
        data: (list) {
          print('list ${list.length}');
          responseList.addAll(list);

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
              return Card(child: ListTile(title: Text(item)));
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
