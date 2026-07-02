import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/debate/repository/debate_room_repository_impl.dart';
import '../../../domain/debate/repository/debate_room_repository.dart';
import 'discussion_remote_data_source_provider.dart';

part 'debate_room_repository_provider.g.dart';

@Riverpod(keepAlive: true)
DebateRoomRepository debateRoomRepository(Ref ref) {
  return DebateRoomRepositoryImpl(
    ref.watch(discussionRemoteDataSourceProvider),
  );
}
