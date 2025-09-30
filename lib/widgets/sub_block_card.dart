
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubBlockCard extends StatefulWidget {
  const SubBlockCard({super.key, required this.index});
  final int index;

  @override
  State<SubBlockCard> createState() => _SubBlockCardState();
}

class _SubBlockCardState extends State<SubBlockCard> {
  String? storeName;
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchStore();
  }

  Future<void> fetchStore() async {
    try {
      final response = await http.get(Uri.parse('http://你的後端網址/api/stores/${widget.index}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          storeName = data['name'] ?? '無名稱';
          loading = false;
        });
      } else {
        setState(() {
          errorMsg = '取得失敗 (${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = '連線錯誤';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 300,
        height: 120,
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : errorMsg != null
                  ? Text(errorMsg!, style: const TextStyle(color: Colors.red))
                  : Text(storeName ?? '無資料', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
