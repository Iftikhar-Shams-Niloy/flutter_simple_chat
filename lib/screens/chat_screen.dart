import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_chat/widgets/chat_messages.dart';
import 'package:flutter_simple_chat/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.withValues(alpha: 0.2),
        title: const Text("SimpleChat"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.withValues(alpha: 1),
              Colors.lightBlueAccent.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: ChatMessages()),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
