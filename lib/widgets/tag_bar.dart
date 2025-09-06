import 'package:flutter/material.dart';

class TagBar extends StatelessWidget {
  const TagBar({
    super.key,
    required this.tags,
    required this.selected,
    required this.onToggle,
  });

  final List<String> tags;
  final Set<String> selected;
  final void Function(String tag) onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final t in tags)
          GestureDetector(
            onTap: () => onToggle(t),
            child: Container(
              width: 100,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected.contains(t)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: selected.contains(t)
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Text(
                t,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected.contains(t)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
