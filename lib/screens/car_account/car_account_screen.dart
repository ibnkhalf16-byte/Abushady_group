import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class CarAccountScreen extends StatefulWidget {
  const CarAccountScreen({super.key});

  @override
  State<CarAccountScreen> createState() => _CarAccountScreenState();
}

class _CarAccountScreenState extends State<CarAccountScreen> {
  List<dynamic> statements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAccount();
  }

  Future<void> fetchAccount() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.carAccount));
      if (res.statusCode == 200) {
        setState(() {
          statements = jsonDecode(res.body);
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
        appBar: AppBar(title: const Text('كشف حساب السيارات'), backgroundColor: AppColors.surface),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: statements.length,
                itemBuilder: (context, index) {
                  final s = statements[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(s['carPlate'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text('إجمالي النقلات: ${s['tripsCount'] ?? 0} | صافي النولون: ${s['netIncome'] ?? 0} ج.م'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

