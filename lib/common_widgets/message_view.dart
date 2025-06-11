import 'package:flutter/cupertino.dart';

class MessageView extends StatelessWidget {
  final String message;

  const MessageView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
