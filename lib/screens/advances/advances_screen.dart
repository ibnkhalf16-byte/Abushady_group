import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class AdvancesScreen extends StatefulWidget {
  const AdvancesScreen({super.key});

  @override
  State<AdvancesScreen> createState() => _AdvancesScreenState();
}

class _AdvancesScreenState extends State<AdvancesScreen> {
  List<dynamic> advances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdvances();
  }

  Future<void> fetchAdvances() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.advances)).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        setState(() {
          advances = jsonDecode(res.body);
          isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      advances = [
        {'personName': 'أحمد علي خلف', 'date': '2026/09/12', 'description': 'سلفة وقود ومصروفات طريق', 'amount': 1500.0, 'transactionType': 'Advance'},
        {'personName': 'محمد إبراهيم', 'date': '2026/09/10', 'description': 'سداد دفعة من السلفة', 'amount': 1000.0, 'transactionType': 'Payment'}
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سلف وسداد السائقين والتباعين'),
          backgroundColor: AppColors.surface,
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: fetchAdvances)],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: advances.length,
                itemBuilder: (context, index) {
                  final a = advances[index];
                  final bool isAdv = a['transactionType'] == 'Advance';
                  final double amt = (a['amount'] as num?)?.toDouble() ?? 0.0;

                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
                    child: ListTile(
                      title: Text(a['personName'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text('${a['date']} • ${a['description'] ?? "بدون بيان"}', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      trailing: Text(
                        '${amt.toStringAsFixed(2)} ج.م',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isAdv ? AppColors.danger : AppColors.success),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

