import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class SafeScreen extends StatefulWidget {
  const SafeScreen({super.key});

  @override
  State<SafeScreen> createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  List<dynamic> safes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSafes();
  }

  Future<void> fetchSafes() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('${ApiConstants.safe}/accounts'));
      if (res.statusCode == 200) {
        setState(() {
          safes = jsonDecode(res.body);
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
          title: const Text('الخزينة والحسابات المالية'),
          backgroundColor: AppColors.surface,
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: fetchSafes)],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: safes.length,
                itemBuilder: (context, index) {
                  final s = safes[index];
                  final double balance = (s['currentBalance'] as num?)?.toDouble() ?? 0.0;
                  final double deposits = (s['totalDeposits'] as num?)?.toDouble() ?? 0.0;
                  final double withdrawals = (s['totalWithdrawals'] as num?)?.toDouble() ?? 0.0;

                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(s['name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                child: Text(s['safeType'] ?? 'نقدية', style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.border, height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('مقبوضات: +${deposits.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.success, fontSize: 13)),
                              Text('مصروفات: -${withdrawals.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('الرصيد الفعلي الحالي:', style: TextStyle(color: Colors.white70)),
                              Text('${balance.toStringAsFixed(2)} ج.م', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          )
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

