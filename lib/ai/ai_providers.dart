import 'package:firebase_ai/firebase_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
Stream<List<String>> generateContentStream(Ref ref, String promptText) async* {
  print('object-  $promptText');

  final modelProvider = ref.watch(geminiFlashModelProvider);

  if (promptText.trim().isEmpty) {
    yield <String>[];
    return;
  }

  final prompt = [Content.text(promptText)];
  final responseStream = modelProvider.generateContentStream(prompt);

  print('stream- $responseStream');

  var allRes = <String>[];
  await for (final event in responseStream) {
    final value = event.text;
    if (value != null && value.isNotEmpty) allRes = [...allRes, value];
    yield allRes;
  }
}
