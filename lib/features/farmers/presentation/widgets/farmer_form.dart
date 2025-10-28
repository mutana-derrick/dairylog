import 'package:flutter/material.dart';
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
    if (_formKey.currentState!.validate()) {
      final farmer = Farmer(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        sector: _sectorController.text.trim(),
        cell: _cellController.text.trim(),
        village: _villageController.text.trim(), id: '23',
      );

      await widget.onSubmit(farmer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputField(
            controller: _nameController,
            labelText: 'Name',
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _phoneController,
            labelText: 'Phone Number',
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter phone number' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _sectorController,
            labelText: 'Sector',
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter sector' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _cellController,
            labelText: 'Cell',
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter cell' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _villageController,
            labelText: 'Village',
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter village' : null,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Farmer',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
