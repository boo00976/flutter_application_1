import 'dart:convert'; // 用來轉成 JSON
import 'package:flutter/material.dart';

class InsertPage extends StatelessWidget {
  const InsertPage({super.key});

  void _showAddMenuSheet(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();

    // 每天的開始 / 結束時間
    final Map<String, Map<String, TimeOfDay?>> weekTimes = {
      "星期一": {"open": null, "close": null},
      "星期二": {"open": null, "close": null},
      "星期三": {"open": null, "close": null},
      "星期四": {"open": null, "close": null},
      "星期五": {"open": null, "close": null},
      "星期六": {"open": null, "close": null},
      "星期日": {"open": null, "close": null},
    };

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
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
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
                      decoration: const InputDecoration(
                        labelText: '店家名稱',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 每天的時間設定
                    ...weekTimes.keys.map((day) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(day, style: const TextStyle(fontSize: 16)),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (picked != null) {
                                        setModalState(() =>
                                            weekTimes[day]!["open"] = picked);
                                      }
                                    },
                                    child: Text(
                                      weekTimes[day]!["open"] == null
                                          ? "開始時間"
                                          : "開始：${weekTimes[day]!["open"]!.format(context)}",
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (picked != null) {
                                        setModalState(() =>
                                            weekTimes[day]!["close"] = picked);
                                      }
                                    },
                                    child: Text(
                                      weekTimes[day]!["close"] == null
                                          ? "結束時間"
                                          : "結束：${weekTimes[day]!["close"]!.format(context)}",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // 確定按鈕
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();

                          if (name.isNotEmpty) {
                            // 轉換成 JSON
                            final storeData = {
                              "name": name,
                              "schedule": weekTimes.map((day, times) {
                                return MapEntry(day, {
                                  "open": times["open"] == null
                                      ? null
                                      : times["open"]!.format(context),
                                  "close": times["close"] == null
                                      ? null
                                      : times["close"]!.format(context),
                                });
                              }),
                            };

                            final jsonStr =
                                const JsonEncoder.withIndent("  ").convert(storeData);
                            print(jsonStr); // 這裡輸出 JSON，你可以存檔或傳給 API

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('確定'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("插入畫面")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("打開新增表單"),
              onPressed: () {
                _showAddMenuSheet(context);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("返回上一頁"),
              onPressed: () {
                Navigator.pop(context); // 返回 MobileLayoutPage
              },
            ),
          ],
        ),
      ),
    );
  }
}
