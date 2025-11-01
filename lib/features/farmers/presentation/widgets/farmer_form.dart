import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/custom_input_field.dart';
import '../../../../core/widgets/custom_button.dart';

// ✅ Changed: Now passes Map instead of Farmer object
typedef OnSubmitFarmer = Future<void> Function(Map<String, String> farmerData);

class FarmerForm extends StatefulWidget {
  final OnSubmitFarmer onSubmit;
  final bool isLoading; // ✅ Added: External loading control

  const FarmerForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<FarmerForm> createState() => _FarmerFormState();
}

class _FarmerFormState extends State<FarmerForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _sectorController.dispose();
    _cellController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ Pass data as Map instead of creating Farmer object
    final farmerData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'sector': _sectorController.text.trim(),
      'cell': _cellController.text.trim(),
      'village': _villageController.text.trim(),
    };

    await widget.onSubmit(farmerData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: AppSpacing.md),

          CustomInputField(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter farmer\'s full name',
            prefixIcon: const Icon(Icons.person_outline),
            enabled: !widget.isLoading, // ✅ Disable when loading
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          CustomInputField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '0781234567',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            enabled: !widget.isLoading, // ✅ Disable when loading
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }

              // ✅ Rwanda phone validation
              final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

              if (cleaned.length != 10) {
                return 'Phone must be 10 digits';
              }

              if (!cleaned.startsWith('07')) {
                return 'Phone must start with 07';
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionTitle('Location Details'),
          const SizedBox(height: AppSpacing.md),

          CustomInputField(
            controller: _sectorController,
            labelText: 'Sector',
            hintText: 'Enter sector',
            prefixIcon: const Icon(Icons.location_city_outlined),
            enabled: !widget.isLoading, // ✅ Disable when loading
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Sector is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          CustomInputField(
            controller: _cellController,
            labelText: 'Cell',
            hintText: 'Enter cell',
            prefixIcon: const Icon(Icons.location_on_outlined),
            enabled: !widget.isLoading, // ✅ Disable when loading
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Cell is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          CustomInputField(
            controller: _villageController,
            labelText: 'Village',
            hintText: 'Enter village',
            prefixIcon: const Icon(Icons.home_outlined),
            enabled: !widget.isLoading, // ✅ Disable when loading
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Village is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Add Farmer',
              onPressed: widget.isLoading ? null : _submit, // ✅ Use external loading
              isLoading: widget.isLoading, // ✅ Use external loading
              icon: Icons.person_add,
            ),
          ),
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
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }
}