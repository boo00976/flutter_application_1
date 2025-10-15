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
          GestureDetector( // 讓整個方塊可點擊（包括 icon 與文字）
            onTap: () => onToggle?.call(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected.contains(t)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: selected.contains(t)
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 按讚按鈕（會改變邊框顏色）
                  IconButton(
                    onPressed: () {
                      onLike?.call(t); // 呼叫外部按讚事件
                      onToggle?.call(t); // 同時觸發邊框選取
                    },
                    icon: Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 26,
                      color: selected.contains(t)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),

                  // 顯示標籤 + 按讚數
                  Text(
                    '${t}${likes.containsKey(t) ? ' (${likes[t]})' : ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected.contains(t)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
