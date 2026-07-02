import '../../../core/error/result.dart';
import '../../../domain/debate/entity/debate_room_entity.dart';
import '../../../domain/debate/repository/debate_room_repository.dart';
import '../data_source/discussion_remote_data_source.dart';
import '../mapper/discussion_room_mapper.dart';

class DebateRoomRepositoryImpl implements DebateRoomRepository {
  const DebateRoomRepositoryImpl(this._remoteDataSource);

  final DiscussionRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<DebateRoomEntity>>> fetchDailyIssueRooms() async {
    final result = await _remoteDataSource.fetchDiscussionRoomList();

    return result.when(
      success: (dtos) {
        final entities = dtos
            .map((dto) => dto.toEntity())
            .toList(growable: false);

        return Success(entities);
      },
      failure: Failure.new,
    );
  }
}
