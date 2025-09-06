import 'package:flutter/material.dart';

class CommentBubble extends StatelessWidget {
  const CommentBubble({
    super.key,
    required this.username,
    required this.content,
    required this.time,
    required this.likes,
    required this.onLike,
  });

  final String username;
  final String content;
  final String time;
  final int likes;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(content),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                      onPressed: onLike,
                    ),
                    Text('$likes'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
