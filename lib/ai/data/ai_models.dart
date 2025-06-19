import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_models.freezed.dart';
part 'ai_models.g.dart';

@freezed
abstract class PromptResponse with _$PromptResponse {
  const factory PromptResponse({
    required int millis,
    required String promptQuery,
    required String promptResult,
    required bool promptDone,
  }) = _PromptResponse;

  factory PromptResponse.fromJson(Map<String, dynamic> json) =>
      _$PromptResponseFromJson(json);
// PromptResponse({
//   required this.promptQuery,
//   required this.promptResult,
//   required this.promptDone,
// });
//
// factory PromptResponse.empty(String promptQuery) => PromptResponse(
//     promptQuery: promptQuery, promptResult: '', promptDone: true);
//
// bool get noResponse => promptResult.isEmpty && promptDone;
}
