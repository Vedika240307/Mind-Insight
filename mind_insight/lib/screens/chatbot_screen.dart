import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  // 🔑 Add your Gemini API Key
  final String apiKey = "AIzaSyCdsvg_lCeNg790duRv6Uovikl78tHDGVw";

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _isTyping = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash-latest:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are Mind Insight AI Assistant, a kind and supportive mental health companion. "
                      "Give short, warm, helpful replies.\nUser: $userMessage",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiMessage =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
            "⚠️ No response received.";

        setState(() {
          _messages.add({"role": "assistant", "text": aiMessage});
          _isTyping = false;
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "text": "⚠️ AI Error. Check your API Key or network.",
          });
          _isTyping = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "text": "❌ Internet or server error.",
        });
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFE91E63);
    const Color lightPink = Color(0xFFFFF0F6);

    return Scaffold(
      backgroundColor: lightPink,
      appBar: AppBar(
        backgroundColor: pink,
        title: const Text(
          "Mind Insight Chatbot",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "AI is typing...",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => sendMessage(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: pink),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      _controller.clear();
                      sendMessage(text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
