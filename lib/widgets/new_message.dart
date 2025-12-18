import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 16, right: 2, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          IconButton(
            onPressed: () {},
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
