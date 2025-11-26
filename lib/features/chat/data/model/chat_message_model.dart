class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}
