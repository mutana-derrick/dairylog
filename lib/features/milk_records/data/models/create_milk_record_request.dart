class CreateMilkRecordRequest {
  final int farmerId;
  final double liters;
  final double pricePerLiter;

  CreateMilkRecordRequest({
    required this.farmerId,
    required this.liters,
    required this.pricePerLiter,
  });

  Map<String, dynamic> toJson() => {
        'farmer_id': farmerId,
        'liters': liters.toString(),
        'price_per_liter': pricePerLiter.toString(),
      };
}