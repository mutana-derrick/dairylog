class CreateFarmerRequest {
  final String farmerName;
  final String phoneNumber;
  final String sector;
  final String cell;
  final String village;

  CreateFarmerRequest({
    required this.farmerName,
    required this.phoneNumber,
    required this.sector,
    required this.cell,
    required this.village,
  });

  Map<String, dynamic> toJson() => {
        'farmer_name': farmerName,
        'phone_number': phoneNumber,
        'sector': sector,
        'cell': cell,
        'village': village,
      };
}