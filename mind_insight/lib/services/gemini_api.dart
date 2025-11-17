import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApi {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiApi({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash', // ✅ stable and free model
      apiKey: apiKey,
    );
  }

  /// Get AI response from Gemini
  Future<String> getResponse(String userMessage) async {
    try {
      // Define the system and user messages
      final List<Content> conversation = [
        Content.text(
          "You are Mind Insight AI Assistant — a helpful, empathetic, and friendly chatbot "
          "for the Mind Insight app. You assist users with mood tracking, meditation, yoga, "
          "doctor consultation, and exercise suggestions. Always reply with kindness and motivation.",
        ),
        Content.text(userMessage),
      ];

      // Generate AI response
      final response = await _model.generateContent(conversation);

      // Extract AI reply text safely
      final reply = response.text?.trim();
      if (reply == null || reply.isEmpty) {
        return "Sorry, I couldn’t understand that. Can you say it differently?";
      }

      return reply;
    } catch (e) {
      print("Gemini API Error: $e");
      return "Sorry — I’m having trouble connecting right now. Please try again later.";
    }
  }
}
