/// Model class representing a milk production report
class Report {
  final String date;
  final double totalQuantity;

  Report({
    required this.date,
    required this.totalQuantity,
  });

  /// Create a Report from DateTime (for dummy data and UI usage)
  factory Report.fromDateTime({
    required DateTime date,
    required double totalQuantity,
  }) {
    return Report(
      date: date.toIso8601String().split('T').first,
      totalQuantity: totalQuantity,
    );
  }

  /// Create a Report from JSON (for API consumption later)
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      date: json['date'] as String,
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
    );
  }

  /// Convert Report to JSON (for API consumption later)
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'totalQuantity': totalQuantity,
    };
  }

  /// Get DateTime object from string date
  DateTime get dateTime => DateTime.parse(date);

  /// Get formatted date string for display
  String get formattedDate {
    final dt = dateTime;
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  /// Create a copy of Report with optional new values
  Report copyWith({
    String? date,
    double? totalQuantity,
  }) {
    return Report(
      date: date ?? this.date,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }

  @override
  String toString() {
    return 'Report(date: $date, totalQuantity: $totalQuantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report &&
        other.date == date &&
        other.totalQuantity == totalQuantity;
  }

  @override
  int get hashCode => date.hashCode ^ totalQuantity.hashCode;

  // ====================
  // DUMMY DATA FOR TESTING
  // ====================

  /// Generate dummy daily reports for the last 7 days
  static List<Report> generateDummyDailyReports() {
    return List.generate(
      7,
      (index) => Report.fromDateTime(
        date: DateTime.now().subtract(Duration(days: 6 - index)),
        totalQuantity: 10 + (index * 5).toDouble(),
      ),
    );
  }

  /// Generate dummy monthly reports for the last 6 months
  static List<Report> generateDummyMonthlyReports() {
    return List.generate(
      6,
      (index) {
        final date = DateTime(
          DateTime.now().year,
          DateTime.now().month - (5 - index),
          1,
        );
        return Report.fromDateTime(
          date: date,
          totalQuantity: 200 + (index * 50).toDouble(),
        );
      },
    );
  }

  /// Generate dummy weekly reports for the last 4 weeks
  static List<Report> generateDummyWeeklyReports() {
    return List.generate(
      4,
      (index) => Report.fromDateTime(
        date: DateTime.now().subtract(Duration(days: (3 - index) * 7)),
        totalQuantity: 50 + (index * 20).toDouble(),
      ),
    );
  }
}