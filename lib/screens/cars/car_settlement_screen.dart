import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class CarSettlementScreen extends StatefulWidget {
  const CarSettlementScreen({super.key});

  @override
  State<CarSettlementScreen> createState() => _CarSettlementScreenState();
}

class _CarSettlementScreenState extends State<CarSettlementScreen> {
  List<dynamic> availableTrips = [];
  final Set<int> selectedTripIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAvailableTrips();
  }

  Future<void> loadAvailableTrips() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('${ApiConstants.carsSettlements}/available-trips'));
      if (res.statusCode == 200) {
        setState(() {
          availableTrips = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  double get totalSelectedNet => availableTrips
      .where((t) => selectedTripIds.contains(t['id']))
      .fold(0.0, (sum, t) => sum + ((t['net'] as num?)?.toDouble() ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تصفية نقلات السيارات'), backgroundColor: AppColors.surface),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: availableTrips.length,
                      itemBuilder: (context, index) {
                        final trip = availableTrips[index];
                        final isSelected = selectedTripIds.contains(trip['id']);

                        return Card(
                          color: isSelected ? const Color(0xFF1E3A8A).withOpacity(0.3) : AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                          ),
                          child: CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedTripIds.add(trip['id']);
                                } else {
                                  selectedTripIds.remove(trip['id']);
                                }
                              });
                            },
                            title: Text('${trip['plateNumber'] ?? "-"} - ${trip['driverName'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('نقلة: ${trip['tripName'] ?? "-"} | صافي: ${trip['net'] ?? 0} ج.م'),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('النقلات المحددة: ${selectedTripIds.length}', style: const TextStyle(color: Colors.white70)),
                            Text('المستحق النهائي: ${totalSelectedNet.toStringAsFixed(2)} ج.م', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                          onPressed: selectedTripIds.isEmpty ? null : () {},
                          child: const Text('اعتماد التصفية', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

