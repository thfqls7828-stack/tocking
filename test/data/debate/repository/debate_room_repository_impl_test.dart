import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/core/error/app_failure.dart';
import 'package:tocking/core/error/result.dart';
import 'package:tocking/core/network/api_client.dart';
import 'package:tocking/data/debate/data_source/discussion_remote_data_source.dart';
import 'package:tocking/data/debate/dto/discussio_room_dto.dart';
import 'package:tocking/data/debate/repository/debate_room_repository_impl.dart';
import 'package:tocking/domain/debate/entity/debate_room_entity.dart';

void main() {
  group('DebateRoomRepositoryImpl', () {
    test('maps discussion room DTOs to debate room entities', () async {
      final repository = DebateRoomRepositoryImpl(
        _FakeDiscussionRemoteDataSource(
          Success([
            DiscussionRoomDto(
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
            ),
          ]),
        ),
      );

      final result = await repository.fetchDailyIssueRooms();

      expect(result, isA<Success<List<DebateRoomEntity>>>());

      final success = result as Success<List<DebateRoomEntity>>;
      expect(success.data, hasLength(1));

      final entity = success.data.single;
      expect(entity.id, '3512');
      expect(entity.category, '생활');
      expect(entity.title, '탈모 치료 건강보험 적용, 합리적인가?');
      expect(entity.proName, '국민 건강 증진 및 의료비 부담 완화');
      expect(entity.conName, '건강보험 재정 악화 및 도덕적 해이');
      expect(entity.proParticipantCount, 1);
      expect(entity.conParticipantCount, 3);
      expect(entity.proPercent, 25);
      expect(entity.conPercent, 75);
    });

    test('passes through data source failures', () async {
      const failure = AppFailure(
        type: AppFailureType.server,
        message: '서버 요청을 처리하지 못했습니다.',
        statusCode: 500,
      );
      final repository = DebateRoomRepositoryImpl(
        _FakeDiscussionRemoteDataSource(const Failure(failure)),
      );

      final result = await repository.fetchDailyIssueRooms();

      expect(result, isA<Failure<List<DebateRoomEntity>>>());

      final failureResult = result as Failure<List<DebateRoomEntity>>;
      expect(failureResult.error, same(failure));
    });
  });
}

class _FakeDiscussionRemoteDataSource extends DiscussionRemoteDataSource {
  _FakeDiscussionRemoteDataSource(this.result) : super(ApiClient(Dio()));

  final Result<List<DiscussionRoomDto>> result;

  @override
  Future<Result<List<DiscussionRoomDto>>> fetchDiscussionRoomList() async {
    return result;
  }
}
