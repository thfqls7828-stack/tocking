import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/data/debate/dto/discussio_room_dto.dart';
import 'package:tocking/data/debate/mapper/discussion_room_mapper.dart';
import 'package:tocking/domain/debate/entity/debate_room_entity.dart';

void main() {
  group('DiscussionRoomDtoMapper', () {
    test('maps a discussion room DTO to a debate room entity', () {
      final dto = DiscussionRoomDto(
        roomId: 3512,
        title: '탈모 치료 건강보험 적용, 합리적인가?',
        newsTitle: "'탈모 건보 적용' 공론화 멈춘 복지부",
        keyPoints: const ['건강보험 재정 건전성', '의료 접근성 확대'],
        proName: '국민 건강 증진 및 의료비 부담 완화',
        proCnt: 1,
        conName: '건강보험 재정 악화 및 도덕적 해이',
        conCnt: 3,
        category: '생활',
        roomType: 'social',
        scenarioText: null,
        status: 'active',
        createdAt: DateTime.parse('2026-07-02T16:22:35'),
      );

      final entity = dto.toEntity();

      expect(entity.id, '3512');
      expect(entity.category, '생활');
      expect(entity.title, '탈모 치료 건강보험 적용, 합리적인가?');
      expect(entity.proName, '국민 건강 증진 및 의료비 부담 완화');
      expect(entity.conName, '건강보험 재정 악화 및 도덕적 해이');
      expect(entity.proParticipantCount, 1);
      expect(entity.conParticipantCount, 3);
      expect(entity.participantCount, 4);
      expect(entity.proPercent, 25);
      expect(entity.conPercent, 75);
    });
  });

  group('DebateRoomEntityMapper', () {
    test('maps a debate room entity to a discussion room DTO', () {
      final createdAt = DateTime.parse('2026-07-02T16:22:35');
      const entity = DebateRoomEntity(
        id: '3512',
        category: '생활',
        title: '탈모 치료 건강보험 적용, 합리적인가?',
        proName: '국민 건강 증진 및 의료비 부담 완화',
        conName: '건강보험 재정 악화 및 도덕적 해이',
        proParticipantCount: 1,
        conParticipantCount: 3,
      );

      final dto = entity.toDto(
        newsTitle: "'탈모 건보 적용' 공론화 멈춘 복지부",
        keyPoints: const ['건강보험 재정 건전성', '의료 접근성 확대'],
        roomType: 'social',
        status: 'active',
        createdAt: createdAt,
      );

      expect(dto.roomId, 3512);
      expect(dto.title, entity.title);
      expect(dto.newsTitle, "'탈모 건보 적용' 공론화 멈춘 복지부");
      expect(dto.keyPoints, ['건강보험 재정 건전성', '의료 접근성 확대']);
      expect(dto.proName, entity.proName);
      expect(dto.proCnt, entity.proParticipantCount);
      expect(dto.conName, entity.conName);
      expect(dto.conCnt, entity.conParticipantCount);
      expect(dto.category, entity.category);
      expect(dto.roomType, 'social');
      expect(dto.scenarioText, isNull);
      expect(dto.status, 'active');
      expect(dto.createdAt, createdAt);
    });
  });
}
