import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart 手機版面',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MobileLayoutPage(),
    );
  }
}

class MobileLayoutPage extends StatefulWidget {
  const MobileLayoutPage({super.key});

  @override
  State<MobileLayoutPage> createState() => _MobileLayoutPageState();
}

class _MobileLayoutPageState extends State<MobileLayoutPage> {
  final List<String> tags = ['全部', '滷肉飯', '雞絲飯', '控肉飯', '雞魯飯'];
  final Set<String> selectedTags = {'全部'};

  // 留言清單（帶 likes 欄位）
  final List<Map<String, dynamic>> comments = [
    {'user': '朋朋 1', 'content': '內容 A', 'time': '10:01', 'likes': 2},
    {'user': '朋朋 2', 'content': '內容 B', 'time': '10:05', 'likes': 0},
  ];

  @override
  Widget build(BuildContext context) {
    // 先排序好留言（依 likes 降序）
    final sortedComments = [...comments]
      ..sort((a, b) => b['likes'].compareTo(a['likes']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('上標 Title'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 子區塊
            _buildSubBlocks(context),
            const SizedBox(height: 12),

            // 標籤欄
            _TagBar(
              tags: tags,
              selected: selectedTags,
              onToggle: _toggleTag,
            ),
            const SizedBox(height: 16),

            // 留言板
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 標題列
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        const Text(
                          '留言板',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                          ),
                          child: Text('${comments.length}'),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: '新增熱門品項',
                          onPressed: _showAddMenuSheet,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 留言列表
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedComments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = sortedComments[index];
                      return _CommentBubble(
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
            ),
          ],
        ),
      ),
    );
  }

  // --- 子區塊 (限制最大寬度 800) ---
  Widget _buildSubBlocks(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 400,
        ),
        child: GridView.count(
          crossAxisCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(
            1,
            (i) => _SubBlockCard(index: i + 1),
          ),
        ),
      ),
    );
  }

  // --- 標籤切換 ---
  void _toggleTag(String t) {
    setState(() {
      if (t == '全部') {
        selectedTags..clear()..add('全部');
      } else {
        if (selectedTags.contains('全部')) selectedTags.remove('全部');
        if (!selectedTags.add(t)) {
          selectedTags.remove(t);
          if (selectedTags.isEmpty) selectedTags.add('全部');
        }
      }
    });
  }

  // --- 新增熱門品項表單 ---
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
              const Text(
                '新增熱門品項',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: '菜名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: '價格',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final price = priceCtrl.text.trim();
                    if (name.isNotEmpty && price.isNotEmpty) {
                      setState(() {
                        tags.add('$name - \$ $price');
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

// --- 子區塊卡片 ---
class _SubBlockCard extends StatelessWidget {
  const _SubBlockCard({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 16, child: Text('$index')),
                const SizedBox(height: 8),
                Text(
                  '子區塊 $index',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 標籤欄 ---
class _TagBar extends StatelessWidget {
  const _TagBar({
    required this.tags,
    required this.selected,
    required this.onToggle,
  });

  final List<String> tags;
  final Set<String> selected;
  final void Function(String tag) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '熱門品項',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final t in tags)
              GestureDetector(
                onTap: () => onToggle(t),
                child: AnimatedScale(
                  scale: selected.contains(t) ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 100,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected.contains(t)
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.15)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected.contains(t)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selected.contains(t)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// --- 留言泡泡 ---
class _CommentBubble extends StatelessWidget {
  const _CommentBubble({
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
        color: Theme.of(context).colorScheme.surface,
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
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
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
