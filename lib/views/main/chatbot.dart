import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(id: "user", firstName: "Swaroop");
  ChatUser geminiUser = ChatUser(id: "model", firstName: "ChatBot");
  bool isThinking = false;

  final String systemPrompt =
      "You are a helpful assistant specialized in farming. Answer only questions related to farming. If a question is outside the scope of farming, respond with 'I can only answer questions related to farming.'";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsUtil.onPrimary,
        backgroundColor: ColorsUtil.primaryColor,
        title: Text(
          "Chat",
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DashChat(
          inputOptions: InputOptions(
            cursorStyle: CursorStyle(
              color: ColorsUtil.primaryColor,
            ),
            sendOnEnter: true,
          ),
          typingUsers: (isThinking) ? [geminiUser] : [],
          messageListOptions: MessageListOptions(typingBuilder: (user) {
            return const Text("Thinking...");
          }),
          messageOptions: MessageOptions(
            currentUserContainerColor: ColorsUtil.primaryColor.withOpacity(0.4),
            currentUserTextColor: ColorsUtil.txtColor,
          ),
          currentUser: currentUser,
          onSend: onSend,
          messages: messages,
        ),
      ),
    );
  }

  void onSend(ChatMessage message) {
    debugPrint(message.text);
    messages = [message, ...messages];
    setState(() {
      isThinking = true;
    });

    List<Content> chatHistory = [
      Content(parts: [Part.text(systemPrompt)], role: "model"),
      ...messages.reversed.map((message) {
        return Content(parts: [Part.text(message.text)], role: message.user.id);
      }).toList(),
    ];

    gemini.chat(chatHistory).then((value) {
      setState(() {
        messages = [
          ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: value!.output ?? ""),
          ...messages
        ];
        isThinking = false;
      });
    });
    setState(() {});
  }
}
