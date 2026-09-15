import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class DriverSettlementsScreen extends StatefulWidget {
  const DriverSettlementsScreen({super.key});

  @override
  State<DriverSettlementsScreen> createState() => _DriverSettlementsScreenState();
}

class _DriverSettlementsScreenState extends State<DriverSettlementsScreen> {
  List<dynamic> settlements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSettlements();
  }

  Future<void> fetchSettlements() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.driverSettlements));
      if (res.statusCode == 200) {
        setState(() {
          settlements = jsonDecode(res.body);
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
        appBar: AppBar(title: const Text('تصفية السائقين والتباعين'), backgroundColor: AppColors.surface),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: settlements.length,
                itemBuilder: (context, index) {
                  final s = settlements[index];
                  final double remaining = (s['remainingAmount'] as num?)?.toDouble() ?? 0.0;

                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
                    child: ListTile(
                      title: Text(s['driverName'] ?? s['loaderName'] ?? 'تصفية', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text('تاريخ: ${s['settlementDate']}', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12)),
                      trailing: Text('${remaining.toStringAsFixed(2)} ج.م', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

