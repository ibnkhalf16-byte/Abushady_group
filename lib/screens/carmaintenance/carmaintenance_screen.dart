import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class CarMaintenanceScreen extends StatefulWidget {
  const CarMaintenanceScreen({super.key});

  @override
  State<CarMaintenanceScreen> createState() => _CarMaintenanceScreenState();
}

class _CarMaintenanceScreenState extends State<CarMaintenanceScreen> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMaintenance();
  }

  Future<void> fetchMaintenance() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.carMaintenance));
      if (res.statusCode == 200) {
        setState(() {
          items = jsonDecode(res.body);
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
        appBar: AppBar(title: const Text('صيانة وإصلاح السيارات'), backgroundColor: AppColors.surface),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final m = items[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text('${m['plateNumber'] ?? "-"} - ${m['description'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text('تاريخ: ${m['date'] ?? "-"} | التكلفة: ${m['amount'] ?? 0} ج.م'),
                      trailing: Text('${m['amount'] ?? 0} ج.م', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

