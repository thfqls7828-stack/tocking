import '../../../core/error/result.dart';
import '../entity/debate_room_entity.dart';

abstract interface class DebateRoomRepository {
  Future<Result<List<DebateRoomEntity>>> fetchDailyIssueRooms();
}
