import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class BasicDataScreen extends StatefulWidget {
  const BasicDataScreen({super.key});

  @override
  State<BasicDataScreen> createState() => _BasicDataScreenState();
}

class _BasicDataScreenState extends State<BasicDataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> data = {'cars': [], 'drivers': [], 'loaders': [], 'customers': []};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('${ApiConstants.basicData}/all'));
      if (res.statusCode == 200) {
        setState(() {
          data = jsonDecode(res.body);
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
          title: const Text('التكويد والبيانات الأساسية'),
          backgroundColor: AppColors.surface,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white60,
            tabs: const [Tab(text: 'السيارات'), Tab(text: 'السائقين'), Tab(text: 'التباعين'), Tab(text: 'العملاء')],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildList(data['cars'], 'plateNumber', 'carName'),
                  _buildList(data['drivers'], 'name', 'phone'),
                  _buildList(data['loaders'], 'name', 'phone'),
                  _buildList(data['customers'], 'name', 'phone'),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<dynamic>? list, String titleKey, String subKey) {
    if (list == null || list.isEmpty) {
      return const Center(child: Text('لا توجد بيانات مسجلة', style: TextStyle(color: Colors.white54)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(item[titleKey] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text(item[subKey] ?? '', style: TextStyle(color: Colors.white.withOpacity(0.55))),
          ),
        );
      },
    );
  }
}

