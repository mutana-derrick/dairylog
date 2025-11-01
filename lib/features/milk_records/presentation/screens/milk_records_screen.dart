import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../../../common/widgets/fab_add_record.dart';
import '../../../../common/widgets/skeletons/list_skeleton.dart';
import '../../../../common/widgets_shared/search_field.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../data/models/milk_record_model.dart';
import '../../providers/milk_provider.dart';
import '../../../farmers/providers/farmers_provider.dart';
import '../widgets/milk_record_card.dart';
import '../screens/milk_details_screen.dart';

class MilkRecordsScreen extends ConsumerStatefulWidget {
  const MilkRecordsScreen({super.key});

  @override
  ConsumerState<MilkRecordsScreen> createState() => _MilkRecordsScreenState();
}

class _MilkRecordsScreenState extends ConsumerState<MilkRecordsScreen> {
  final int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTap(BuildContext context, int index) {
    if (_currentIndex == index) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // Already on milk records
        break;
      case 2:
        context.go('/farmers');
        break;
      case 3:
        context.go('/reports');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  List<MilkRecord> _filterRecords(List<MilkRecord> records) {
    if (_searchQuery.isEmpty) return records;

    return records.where((record) {
      final farmerPhone = record.farmerPhone.toLowerCase();
      final quantity = record.liters.toString();
      final query = _searchQuery.toLowerCase();

      return farmerPhone.contains(query) || quantity.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final milkState = ref.watch(milkRecordsNotifierProvider);
    final farmersNotifier = ref.read(farmersNotifierProvider.notifier);

    final filteredRecords = _filterRecords(milkState.records);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Milk Records'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search section
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Milk Collections',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${milkState.records.length} total records',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SearchField(
                  controller: _searchController,
                  hintText: 'Search by farmer phone, or quantity...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${filteredRecords.length} result${filteredRecords.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Records list
          Expanded(
            child: milkState.isLoading
                ? const ListSkeleton()
                : filteredRecords.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          // TODO: Refresh data
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = filteredRecords[index];
                            return MilkRecordCard(
                              record: record,
                              onTap: () async {
                                final farmer = await farmersNotifier.lookupFarmer(
                                  record.farmerPhone,
                                );

                                if (farmer != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MilkDetailsScreen(
                                        record: record,
                                        farmer: farmer,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Farmer not found'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FabAddRecord(
        onPressed: () {
          context.push('/addMilkRecord');
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearchQuery = _searchQuery.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Icon(
                hasSearchQuery ? Icons.search_off : Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasSearchQuery ? 'No Results Found' : 'No Milk Records Yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasSearchQuery
                  ? 'Try adjusting your search terms'
                  : 'Start by adding your first milk collection record',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasSearchQuery) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
