import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/debate/data_source/discussion_remote_data_source.dart';
import '../../network/api_client.dart';

part 'discussion_remote_data_source_provider.g.dart';

@Riverpod(keepAlive: true)
DiscussionRemoteDataSource discussionRemoteDataSource(Ref ref) {
  return DiscussionRemoteDataSource(ref.watch(apiClientProvider));
}
