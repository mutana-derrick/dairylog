import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../../../common/widgets/fab_add_record.dart';
import '../../../../common/widgets_shared/search_field.dart';
import '../../providers/farmers_provider.dart';
import '../../data/models/farmer_model.dart';
import '../widgets/farmer_card.dart';

class FarmersScreen extends ConsumerStatefulWidget {
  const FarmersScreen({super.key});

  @override
  ConsumerState<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends ConsumerState<FarmersScreen> {
  final int _currentIndex = 2;
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
        context.go('/milk-records');
        break;
      case 2:
        // Already on farmers
        break;
      case 3:
        context.go('/reports');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  List<Farmer> _filterFarmers(List<Farmer> farmers) {
    if (_searchQuery.isEmpty) return farmers;

    return farmers.where((farmer) {
      final name = farmer.name.toLowerCase();
      final phone = farmer.phoneNumber.toLowerCase();
      final sector = farmer.sector.toLowerCase();
      final cell = farmer.cell.toLowerCase();
      final village = farmer.village.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) ||
          phone.contains(query) ||
          sector.contains(query) ||
          cell.contains(query) ||
          village.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(farmersNotifierProvider);
    final notifier = ref.read(farmersNotifierProvider.notifier);

    final filteredFarmers = _filterFarmers(state.farmers);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farmers'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with search
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.farmers.length} Registered',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total farmers in database',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SearchField(
                  controller: _searchController,
                  hintText: 'Search by name, phone, or location...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${filteredFarmers.length} result${filteredFarmers.length != 1 ? 's' : ''} found',
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

          // Farmers list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await notifier.loadFarmers(),
              color: AppColors.primary,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredFarmers.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          itemCount: filteredFarmers.length,
                          itemBuilder: (context, index) {
                            final farmer = filteredFarmers[index];
                            return FarmerCard(farmer: farmer);
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FabAddRecord(
        onPressed: () {
          context.push('/addFarmers');
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                hasSearchQuery ? Icons.search_off : Icons.person_add_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasSearchQuery ? 'No Farmers Found' : 'No Farmers Yet',
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
                  : 'Start by adding your first farmer\nto the database',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            hasSearchQuery
                ? OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Search'),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      context.push('/addFarmers');
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add First Farmer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
