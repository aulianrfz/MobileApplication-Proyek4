class HistoryData {
  final String appName;
  final DateTime generatedAt;
  final String status;

  HistoryData({
    required this.appName,
    required this.generatedAt,
    required this.status,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      appName: json['app_name'],
      generatedAt: DateTime.parse(json['generated_at']),
      status: json['status'],
    );
  }
}
