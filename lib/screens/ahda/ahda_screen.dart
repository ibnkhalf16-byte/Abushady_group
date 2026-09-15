import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class AhdaScreen extends StatefulWidget {
  const AhdaScreen({super.key});

  @override
  State<AhdaScreen> createState() => _AhdaScreenState();
}

class _AhdaScreenState extends State<AhdaScreen> {
  List<dynamic> summaries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  Future<void> loadSummary() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('${ApiConstants.ahda}/summary'));
      if (res.statusCode == 200) {
        setState(() {
          summaries = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كشف حساب العهد الشهرية'),
          backgroundColor: AppColors.surface,
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: loadSummary)],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: summaries.length,
                itemBuilder: (context, index) {
                  final s = summaries[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          const Divider(color: AppColors.border),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('رصيد منقول: ${s['previousBalance'] ?? 0} ج.م', style: const TextStyle(color: Colors.white70)),
                              Text('+ مضاف: ${s['totalAdded'] ?? 0} ج.م', style: const TextStyle(color: AppColors.success)),
                              Text('- منصرف: ${s['totalSpent'] ?? 0} ج.م', style: const TextStyle(color: AppColors.danger)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('صافي الرصيد: ${s['netBalance'] ?? 0} ج.م', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

