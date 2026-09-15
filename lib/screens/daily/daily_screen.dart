import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  List<dynamic> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(ApiConstants.dailyTrips)).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        setState(() {
          trips = jsonDecode(res.body);
          isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      trips = [
        {
          'id': 1,
          'date': '2026/09/15',
          'carPlate': 'ط د ج 1584',
          'driverName': 'محمد إبراهيم',
          'tripName': 'محجر السادات - مصنع الإسمنت',
          'weight': 42.50,
          'pricePerTon': 120.0,
          'totalValue': 5100.0,
          'trustAmount': 1500.0,
          'netAmount': 3600.0,
          'isSettled': false
        },
        {
          'id': 2,
          'date': '2026/09/14',
          'carPlate': 'ق س ر 9821',
          'driverName': 'أحمد علي خلف',
          'tripName': 'العامرية - ميناء الإسكندرية',
          'weight': 38.00,
          'pricePerTon': 145.0,
          'totalValue': 5510.0,
          'trustAmount': 2000.0,
          'netAmount': 3510.0,
          'isSettled': true
        },
        {
          'id': 3,
          'date': '2026/09/14',
          'carPlate': 'ي ع ل 4563',
          'driverName': 'محمود السيد',
          'tripName': 'السويس - العاشر من رمضان',
          'weight': 45.20,
          'pricePerTon': 110.0,
          'totalValue': 4972.0,
          'trustAmount': 1200.0,
          'netAmount': 3772.0,
          'isSettled': false
        }
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
          title: const Text('اليومية ومتابعة النقلات'),
          backgroundColor: AppColors.surface,
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: fetchTrips)],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : trips.isEmpty
                ? const Center(child: Text('لا توجد نقلات مسجلة حالياً', style: TextStyle(color: Colors.white60, fontSize: 16)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final t = trips[index];
                      final bool isSettled = t['isSettled'] ?? false;

                      return Card(
                        color: AppColors.surface,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${t['carPlate'] ?? "-"} • ${t['driverName'] ?? "-"}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (isSettled ? AppColors.warning : AppColors.success).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isSettled ? '🔒 مصفاة' : 'جاهزة للتصفية',
                                      style: TextStyle(
                                        color: isSettled ? AppColors.warning : AppColors.success,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(t['tripName'] ?? '', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12.5)),
                              const Divider(color: AppColors.border, height: 22),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('الوزن: ${t['weight']} طن', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                  Text('النولون: ${t['pricePerTon']} ج.م', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                  Text('القيمة: ${t['totalValue']} ج.م', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('العهدة: ${t['trustAmount']} ج.م', style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                                  Text('الصافي: ${t['netAmount']} ج.م', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
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

