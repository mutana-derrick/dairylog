import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input_field.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../farmers/data/models/farmer_model.dart';
import '../../../farmers/providers/farmers_provider.dart';



class MilkInputForm extends ConsumerStatefulWidget {
  final Function({
    required int farmerId,
    required String farmerName,
    required String farmerPhone,
    required double liters,
    required double pricePerLiter,
  }) onSubmit;
  final bool isLoading;

  const MilkInputForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  ConsumerState<MilkInputForm> createState() => _MilkInputFormState();
}

class _MilkInputFormState extends ConsumerState<MilkInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Farmer? _selectedFarmer;
  List<Farmer> _filteredFarmers = [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _filterFarmers(String query, List<Farmer> allFarmers) {
    if (query.isEmpty) {
      setState(() {
        _filteredFarmers = [];
        _showSuggestions = false;
        _selectedFarmer = null;
      });
      return;
    }

    setState(() {
      _filteredFarmers = allFarmers
          .where((farmer) =>
              farmer.phoneNumber.contains(query) ||
              farmer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showSuggestions = _filteredFarmers.isNotEmpty;

      // Auto-select if exact match
      try {
        _selectedFarmer = allFarmers.firstWhere(
          (f) => f.phoneNumber == query,
        );
        _showSuggestions = false;
      } catch (e) {
        _selectedFarmer = null;
      }
    });
  }

  void _selectFarmer(Farmer farmer) {
    setState(() {
      _selectedFarmer = farmer;
      _phoneController.text = farmer.phoneNumber;
      _showSuggestions = false;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFarmer == null) {
        ToastUtils.showError(
            'Farmer not found. Please check the phone number.');
        return;
      }

      await widget.onSubmit(
        farmerId: _selectedFarmer!.id,
        farmerName: _selectedFarmer!.name,
        farmerPhone: _selectedFarmer!.phoneNumber,
        liters: double.parse(_quantityController.text),
        pricePerLiter: double.parse(_priceController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get farmers from provider
    final farmersState = ref.watch(farmersNotifierProvider);
    final farmers = farmersState.farmers;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhoneNumberField(farmers),
          if (_selectedFarmer != null) _buildFarmerPreview(),
          if (_showSuggestions && _filteredFarmers.isNotEmpty)
            _buildSuggestionsList(),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionTitle('Milk Details'),
          const SizedBox(height: AppSpacing.md),
          _buildQuantityField(),
          const SizedBox(height: AppSpacing.md),
          _buildPriceField(),
          const SizedBox(height: AppSpacing.md),
          if (_quantityController.text.isNotEmpty &&
              _priceController.text.isNotEmpty)
            _buildTotalPreview(),
          const SizedBox(height: AppSpacing.xl),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(List<Farmer> farmers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Farmer Information'),
        const SizedBox(height: AppSpacing.md),
        CustomInputField(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter or search farmer phone',
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined),
          enabled: !widget.isLoading,
          onChanged: (value) => _filterFarmers(value, farmers),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (_selectedFarmer == null) {
              return 'Farmer not found';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFarmerPreview() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.cream,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedFarmer!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_selectedFarmer!.sector} • ${_selectedFarmer!.cell}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        itemCount: _filteredFarmers.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final farmer = _filteredFarmers[index];
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Text(
                farmer.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              farmer.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              farmer.phoneNumber,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
            onTap: () => _selectFarmer(farmer),
          );
        },
      ),
    );
  }

  Widget _buildQuantityField() {
    return CustomInputField(
      controller: _quantityController,
      labelText: 'Quantity',
      hintText: 'Enter quantity in liters',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: const Icon(Icons.water_drop_outlined),
      suffixText: 'Liters',
      enabled: !widget.isLoading,
      onChanged: (value) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter quantity';
        if (double.tryParse(value) == null) return 'Enter a valid number';
        if (double.parse(value) <= 0) return 'Quantity must be greater than 0';
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return CustomInputField(
      controller: _priceController,
      labelText: 'Price per Liter',
      hintText: 'Enter price per liter',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: const Icon(Icons.attach_money_outlined),
      suffixText: 'RWF',
      enabled: !widget.isLoading,
      onChanged: (value) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter price';
        if (double.tryParse(value) == null) return 'Enter a valid number';
        if (double.parse(value) <= 0) return 'Price must be greater than 0';
        return null;
      },
    );
  }

  Widget _buildTotalPreview() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    final total = quantity * price;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calculate_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Estimated Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            'RWF ${total.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Add Record',
        onPressed: widget.isLoading ? null : _handleSubmit,
        isLoading: widget.isLoading,
        icon: Icons.add,
      ),
    );
  }
}
