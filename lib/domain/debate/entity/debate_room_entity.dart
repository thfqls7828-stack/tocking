class DebateRoomEntity {
  const DebateRoomEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.proName,
    required this.conName,
    required this.proParticipantCount,
    required this.conParticipantCount,
  });

  final String id;
  final String category;
  final String title;
  final String proName;
  final String conName;
  final int proParticipantCount;
  final int conParticipantCount;

  DebateRoomEntity copyWith({
    String? id,
    String? category,
    String? title,
    String? proName,
    String? conName,
    int? proParticipantCount,
    int? conParticipantCount,
  }) {
    return DebateRoomEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      proName: proName ?? this.proName,
      conName: conName ?? this.conName,
      proParticipantCount: proParticipantCount ?? this.proParticipantCount,
      conParticipantCount: conParticipantCount ?? this.conParticipantCount,
    );
  }

  int get participantCount => proParticipantCount + conParticipantCount;

  int get proPercent => _percentOf(proParticipantCount);
  int get conPercent => _percentOf(conParticipantCount);

  int _percentOf(int count) {
    if (participantCount == 0) {
      return 0;
    }

    return ((count / participantCount) * 100).round();
  }
}
