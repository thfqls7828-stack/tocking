class DiscussionRoomDto {
  const DiscussionRoomDto({
    required this.roomId,
    required this.title,
    required this.newsTitle,
    required this.keyPoints,
    required this.proName,
    required this.proCnt,
    required this.conName,
    required this.conCnt,
    required this.category,
    required this.roomType,
    required this.scenarioText,
    required this.status,
    required this.createdAt,
  });

  final int roomId;
  final String title;
  final String newsTitle;
  final List<String> keyPoints;
  final String proName;
  final int proCnt;
  final String conName;
  final int conCnt;
  final String category;
  final String roomType;
  final String? scenarioText;
  final String status;
  final DateTime createdAt;

  factory DiscussionRoomDto.fromJson(Map<String, dynamic> json) {
    return DiscussionRoomDto(
      roomId: json['roomId'] as int,
      title: json['title'] as String,
      newsTitle: json['newsTitle'] as String,
      keyPoints: (json['keyPoints'] as List).cast<String>(),
      proName: json['proName'] as String,
      proCnt: json['proCnt'] as int,
      conName: json['conName'] as String,
      conCnt: json['conCnt'] as int,
      category: json['category'] as String,
      roomType: json['roomType'] as String,
      scenarioText: json['scenarioText'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'title': title,
      'newsTitle': newsTitle,
      'keyPoints': keyPoints,
      'proName': proName,
      'proCnt': proCnt,
      'conName': conName,
      'conCnt': conCnt,
      'category': category,
      'roomType': roomType,
      'scenarioText': scenarioText,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
