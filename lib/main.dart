import 'package:flutter/material.dart';
import 'widgets/comment_bubble.dart';

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
  final Set<String> selectedTags = {'全部'};

  // 留言清單：加上 likes 欄位
  final List<Map<String, dynamic>> comments = [
    {'user': '店家名稱1', 'content': 'er,#footer{background:#fff7db;}#header{border-bottom:8pxsolid#ffc300;}#footer{border-top:8pxsolid#ffc300;}#main{display:flex;flex-flow:rowwrap;font-size:20px;}#main.content{width:68%;padding:0.5rem0;}#main.sidebar{overflow:hidden;width:31.884%;border-left:3pxsolid#007300;padding:0.5rem00.5rem3px;}#main.OneColumn{margin:0auto;clear:both;width:100%;padding:0.5rem0;}h1{border-left:8pxsolid#7bff00;border-right:8pxsolid#7bff00;font-size:1.6em;line-height:1.25em;margin:20px0;}h2{border-left:8pxsolidred;font-size:1.2em;line-height:1.51em;margin:12px0;}h3{border-bottom:3pxsolid#de7a7b;}h1,h2,h3{background:#e5ecf9;border-radius:10px;padding:5px;}h3,h4,h5{margin:10px0;}input{font-size:1.5rem;line-height:2.55rem;margin:010px10px10px;}a:link,a:visited{text-decoration:none;}a:active,a:hover{text-decoration:underline;}.extln{background-position:centerright;background-repeat:no-repeat;background-image:url("/images/extlnk.png");padding-right:13px;}.red{color:#A80000;}', 'time': '10:01', 'likes': 2},
    {'user': '店家名稱2', 'content': '內容 B', 'time': '10:05', 'likes': 0},
  ];

  // Simple placeholder for the sub-blocks area (keeps this file self-contained)
  Widget _buildSubBlocks(BuildContext context) {
    return Center(
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSubBlocks(context),

            const SizedBox(height: 12),
            const SizedBox(height: 16),

            // 留言板
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
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
                          '店家:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                          ),
                          child: Text('${comments.length}'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 留言列表 (按讚數排序)
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final sortedComments = [...comments]
                        ..sort((a, b) => b['likes'].compareTo(a['likes']));
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
            ),
          ],
        ),
      ),
    );
  }
}