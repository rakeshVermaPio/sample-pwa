import 'package:firebase_ai/firebase_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/ai/data/ai_models.dart';

part 'ai_providers.g.dart';

@Riverpod(keepAlive: true)
GenerativeModel geminiFlashModel(Ref ref) {
  print('init FirebaseAi-Gemini-flash-model');
  return FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
}

@riverpod
Future<GenerateContentResponse> generateContentResponse(
    Ref ref, String promptText) async {
  final prompt = [Content.text(promptText)];
  final response =
      await ref.watch(geminiFlashModelProvider).generateContent(prompt);
  print('response- ${response.text}');
  return response;
}

@riverpod
Stream<PromptResponse> generateContentStream(
    Ref ref, String promptText) async* {
  print('object- $promptText');

  final modelProvider = ref.watch(geminiFlashModelProvider);
  final promptResponseEmpty = PromptResponse(
    millis: DateTime.now().millisecondsSinceEpoch,
      promptQuery: promptText, promptResult: '', promptDone: true);
  if (promptText.trim().isEmpty) {
    yield promptResponseEmpty;
    return;
  }

  final prompt = [Content.text(promptText)];
  final responseStream = modelProvider.generateContentStream(prompt);

  print('stream- $responseStream');

  var promptResponse = promptResponseEmpty.copyWith(millis: DateTime.now().millisecondsSinceEpoch);
  await for (final event in responseStream) {
    print(
        'stream - for - ${event.usageMetadata} -> ${event.text} -> ${event.candidates.length}');
    final candidates = event.candidates;
    final promptDone =
        candidates.any((e) => e.finishReason == FinishReason.stop);
    final value = event.text;
    if (value != null && value.isNotEmpty) {
      final promptResult = '${promptResponse.promptResult}$value';
      promptResponse = promptResponse.copyWith(
          promptQuery: promptText,
          promptResult: promptResult,
          promptDone: promptDone);
      yield promptResponse;
    }
  }
}
