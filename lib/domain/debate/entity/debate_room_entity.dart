class DebateRoomEntity {
  const DebateRoomEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.proParticipantCount,
    required this.conParticipantCount,
    required this.remainingTime,
  });

  final String id;
  final String category;
  final String title;
  final int proParticipantCount;
  final int conParticipantCount;
  final Duration remainingTime;

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
