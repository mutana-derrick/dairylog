import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/custom_input_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/farmer_model.dart';

typedef OnSubmitFarmer = Future<void> Function(Farmer farmer);

class FarmerForm extends StatefulWidget {
  final OnSubmitFarmer onSubmit;

  const FarmerForm({super.key, required this.onSubmit});

  @override
  State<FarmerForm> createState() => _FarmerFormState();
}

class _FarmerFormState extends State<FarmerForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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

    setState(() => _isLoading = true);

    try {
      final farmer = Farmer(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        sector: _sectorController.text.trim(),
        cell: _cellController.text.trim(),
        village: _villageController.text.trim(),
      );

      await widget.onSubmit(farmer);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter name';
              if (value.length < 3) return 'Name too short';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          
          CustomInputField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter phone number';
              if (value.length < 10) return 'Invalid phone number';
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
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter sector' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          
          CustomInputField(
            controller: _cellController,
            labelText: 'Cell',
            hintText: 'Enter cell',
            prefixIcon: const Icon(Icons.location_on_outlined),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter cell' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          
          CustomInputField(
            controller: _villageController,
            labelText: 'Village',
            hintText: 'Enter village',
            prefixIcon: const Icon(Icons.home_outlined),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter village' : null,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Add Farmer',
              onPressed: _isLoading ? null : () => _submit(),
              isLoading: _isLoading,
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
