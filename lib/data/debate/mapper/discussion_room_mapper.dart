import '../../../domain/debate/entity/debate_room_entity.dart';
import '../dto/discussio_room_dto.dart';

extension DiscussionRoomDtoMapper on DiscussionRoomDto {
  DebateRoomEntity toEntity() {
    return DebateRoomEntity(
      id: roomId.toString(),
      category: category,
      title: title,
      proName: proName,
      conName: conName,
      proParticipantCount: proCnt,
      conParticipantCount: conCnt,
    );
  }
}

extension DebateRoomEntityMapper on DebateRoomEntity {
  DiscussionRoomDto toDto({
    required String newsTitle,
    required List<String> keyPoints,
    required String roomType,
    required String status,
    required DateTime createdAt,
    String? scenarioText,
  }) {
    return DiscussionRoomDto(
      roomId: int.parse(id),
      title: title,
      newsTitle: newsTitle,
      keyPoints: List.unmodifiable(keyPoints),
      proName: proName,
      proCnt: proParticipantCount,
      conName: conName,
      conCnt: conParticipantCount,
      category: category,
      roomType: roomType,
      scenarioText: scenarioText,
      status: status,
      createdAt: createdAt,
    );
  }
}
