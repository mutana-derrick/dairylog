import 'package:flutter/material.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input_field.dart';
import '../../../farmers/data/models/farmer_model.dart';
import '../../data/models/milk_record_model.dart';


class MilkInputForm extends StatefulWidget {
  final Function(MilkRecord) onSubmit;
  final MilkRecord? initialRecord; // optional, for editing
  final List<Farmer> farmers; // list of farmers for phone number autocomplete

  const MilkInputForm({
    super.key,
    required this.onSubmit,
    this.initialRecord,
    required this.farmers,
  });

  @override
  State<MilkInputForm> createState() => _MilkInputFormState();
}

class _MilkInputFormState extends State<MilkInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Farmer? _selectedFarmer;

  @override
  void initState() {
    super.initState();
    if (widget.initialRecord != null) {
      _phoneController.text = widget.initialRecord!.farmerPhoneNumber;
      _quantityController.text = widget.initialRecord!.quantity.toString();
      _priceController.text = widget.initialRecord!.price.toString();
      _selectedFarmer = widget.farmers.firstWhere(
        (f) => f.phoneNumber == widget.initialRecord!.farmerPhoneNumber,
        orElse: () => Farmer(id: '', phoneNumber: '', name: '', sector: '', cell: '', village: ''),
      );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFarmer == null || _selectedFarmer!.phoneNumber.isEmpty) {
        ToastUtils.showError('Farmer not found. Please check the phone number.');
        return;
      }

      final record = MilkRecord(
        // id: widget.initialRecord?.id,
        farmerPhoneNumber: _phoneController.text,
        quantity: double.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        date: DateTime.now(),
      );

      widget.onSubmit(record);
    }
  }

  // void _onPhoneChanged(String value) {
  //   final match = widget.farmers.where((f) => f.phoneNumber == value).toList();
  //   if (match.isNotEmpty) {
  //     setState(() {
  //       _selectedFarmer = match.first;
  //     });
  //   } else {
  //     setState(() {
  //       _selectedFarmer = null;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputField(
            controller: _phoneController,
            labelText: 'Farmer Phone Number',
            keyboardType: TextInputType.phone,
            // onChanged: _onPhoneChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _quantityController,
            labelText: 'Quantity (Liters)',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter quantity';
              if (double.tryParse(value) == null) return 'Enter a valid number';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomInputField(
            controller: _priceController,
            labelText: 'Price (RWF)',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter price';
              if (double.tryParse(value) == null) return 'Enter a valid number';
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: widget.initialRecord == null ? 'Add Record' : 'Update Record',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
