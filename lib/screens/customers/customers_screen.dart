import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<dynamic> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.customers)).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        setState(() {
          customers = jsonDecode(res.body);
          isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      customers = [
        {'name': 'شركة الأمل لمواد البناء', 'phone': '01012345678', 'currentBalance': 125000.0},
        {'name': 'مؤسسة النيل للأسمنت', 'phone': '01298765432', 'currentBalance': -4500.0}
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
          title: const Text('حسابات العملاء'),
          backgroundColor: AppColors.surface,
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: fetchCustomers)],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final c = customers[index];
                  final double balance = (c['currentBalance'] as num?)?.toDouble() ?? 0.0;

                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
                    child: ListTile(
                      title: Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text(c['phone'] ?? 'بدون هاتف', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12)),
                      trailing: Text(
                        '${balance.toStringAsFixed(2)} ج.م',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: balance >= 0 ? AppColors.success : AppColors.danger),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

