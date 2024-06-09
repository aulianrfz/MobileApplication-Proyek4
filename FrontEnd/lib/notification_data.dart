class NotificationData {
  final String message;

  NotificationData({required this.message});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'],
    );
  }
}
