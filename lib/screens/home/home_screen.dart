import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../daily/daily_screen.dart';
import '../ahda/ahda_screen.dart';
import '../advances/advances_screen.dart';
import '../customers/customers_screen.dart';
import '../cars/car_settlement_screen.dart';
import '../driver_settlements/driver_settlements_screen.dart';
import '../safe/safe_screen.dart';
import '../car_account/car_account_screen.dart';
import '../carmaintenance/carmaintenance_screen.dart';
import '../basic_data/basic_data_screen.dart';
import '../users/users_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'اليومية', 'icon': Icons.calendar_month_rounded, 'grad': [const Color(0xFF2563EB), const Color(0xFF1D4ED8)], 'screen': const DailyScreen()},
      {'title': 'العهد', 'icon': Icons.assignment_rounded, 'grad': [const Color(0xFF7C3AED), const Color(0xFF5B21B6)], 'screen': const AhdaScreen()},
      {'title': 'سلف سائقين', 'icon': Icons.account_balance_wallet_rounded, 'grad': [const Color(0xFF0891B2), const Color(0xFF0E7490)], 'screen': const AdvancesScreen()},
      {'title': 'حسابات العملاء', 'icon': Icons.groups_rounded, 'grad': [const Color(0xFF059669), const Color(0xFF047857)], 'screen': const CustomersScreen()},
      {'title': 'تصفية سيارات', 'icon': Icons.local_shipping_rounded, 'grad': [const Color(0xFFEA580C), const Color(0xFFC2410C)], 'screen': const CarSettlementScreen()},
      {'title': 'تصفية سائق', 'icon': Icons.badge_rounded, 'grad': [const Color(0xFFDB2777), const Color(0xFFBE185D)], 'screen': const DriverSettlementsScreen()},
      {'title': 'الخزنة', 'icon': Icons.savings_rounded, 'grad': [const Color(0xFFD97706), const Color(0xFFB45309)], 'screen': const SafeScreen()},
      {'title': 'كشف حساب سيارة', 'icon': Icons.analytics_rounded, 'grad': [const Color(0xFF4F46E5), const Color(0xFF3730A3)], 'screen': const CarAccountScreen()},
      {'title': 'صيانة سيارة', 'icon': Icons.build_circle_rounded, 'grad': [const Color(0xFF64748B), const Color(0xFF334155)], 'screen': const CarMaintenanceScreen()},
      {'title': 'التكويد', 'icon': Icons.settings_suggest_rounded, 'grad': [const Color(0xFF0F766E), const Color(0xFF115E59)], 'screen': const BasicDataScreen()},
      {'title': 'المستخدمين', 'icon': Icons.manage_accounts_rounded, 'grad': [const Color(0xFF475569), const Color(0xFF1E293B)], 'screen': const UsersScreen()},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 30),
                          SizedBox(width: 10),
                          Text(
                            'أبو شادي لمقاولات النقل',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'نظام إدارة ومتابعة مقاولات النقل والحسابات',
                        style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = menuItems[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => item['screen']));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: item['grad']),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(item['icon'], color: Colors.white, size: 28),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['title'],
                                style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: menuItems.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

