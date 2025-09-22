import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/sub_block_card.dart';
import 'widgets/tag_bar.dart';
import 'widgets/comment_bubble.dart';

class MobileLayoutPage extends StatefulWidget {
  const MobileLayoutPage({super.key});

  @override
  State<MobileLayoutPage> createState() => _MobileLayoutPageState();
}

class _MobileLayoutPageState extends State<MobileLayoutPage> {
  final List<String> tags = ['全部', '滷肉飯', '雞絲飯', '控肉飯', '雞魯飯'];
  final Set<String> selectedTags = {'全部'};

  final List<Map<String, dynamic>> comments = [
    {'user': '朋朋 1', 'content': '內容 A', 'time': '10:01', 'likes': 1},
    {'user': '朋朋 2', 'content': '內容 B', 'time': '10:05', 'likes': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上標 Title'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSubBlocks(context),
            const SizedBox(height: 12),
            TagBar(
              tags: tags,
              selected: selectedTags,
              onToggle: (t) {
                setState(() {
                  if (t == '全部') {
                    selectedTags
                      ..clear()
                      ..add('全部');
                  } else {
                    if (selectedTags.contains('全部')) selectedTags.remove('全部');
                    if (!selectedTags.add(t)) {
                      selectedTags.remove(t);
                      if (selectedTags.isEmpty) selectedTags.add('全部');
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            _buildCommentBoard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubBlocks(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 400),
        child: GridView.count(
          crossAxisCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(1, (i) => SubBlockCard(index: i + 1)),
        ),
      ),
    );
  }

  Widget _buildCommentBoard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text('留言板', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: '新增熱門品項',
                  onPressed: _showAddMenuSheet,
                ),
              ],
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final sortedComments = [...comments]..sort((a, b) => b['likes'].compareTo(a['likes']));
              final c = sortedComments[index];
              return CommentBubble(
                username: c['user'],
                content: c['content'],
                time: c['time'],
                likes: c['likes'],
                onLike: () {
                  setState(() {
                    c['likes']++;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

// --- 滑出新增熱門品項表單 ---
  void _showAddMenuSheet() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '菜名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isNotEmpty) {
                      setState(() {
                        tags.add('$name');
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('確定'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
