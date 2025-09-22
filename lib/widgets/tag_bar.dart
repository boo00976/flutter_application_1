import 'package:flutter/material.dart';

class TagBar extends StatelessWidget {
  const TagBar({
    super.key,
    required this.tags,
    this.selected = const {},
    this.onToggle,
    this.likes = const {},
    this.onLike,
  });

  final List<String> tags;

  // 舊功能：標籤選取
  final Set<String> selected;
  final void Function(String tag)? onToggle;

  // 新功能：按讚排序
  final Map<String, int> likes;
  final void Function(String tag)? onLike;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final t in tags)
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected.contains(t)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 按讚按鈕（新功能）
                IconButton(
                  onPressed: () => onLike?.call(t),
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 30),
                ),
                // 標籤文字（舊功能 + 顯示讚數）
                GestureDetector(
                  onTap: onToggle != null ? () => onToggle!(t) : null,
                  child: Text(
                    '${t}${likes.containsKey(t) ? ' (${likes[t]})' : ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected.contains(t)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

