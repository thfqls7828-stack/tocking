import 'package:tocking/data/debate/dto/discussio_room_dto.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/result.dart';
import '../../../core/network/api_client.dart';

class DiscussionRemoteDataSource {
  const DiscussionRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Result<List<DiscussionRoomDto>>> fetchDiscussionRoomList() async {
    try {
      final response = await _apiClient.post<Object>('/api/discussion/suggest');

      final responseData = response.data;
      if (response.statusCode != 200) {
        throw FormatException('Unexpected status code: ${response.statusCode}');
      }

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('Response must be a JSON object.');
      }

      if (responseData['code'] != 'OK' || responseData['result'] != 'success') {
        throw const FormatException('API response is not successful.');
      }

      final data = responseData['data'];
      if (data is! Map<String, dynamic>) {
        throw const FormatException('data must be a JSON object.');
      }

      final topics = data['socialDebateTopic'];
      if (topics is! List) {
        throw const FormatException('socialDebateTopic must be a list.');
      }

      final dtos = <DiscussionRoomDto>[];
      for (final topic in topics) {
        if (topic is! Map<String, dynamic>) {
          throw const FormatException('Discussion room must be a JSON object.');
        }

        dtos.add(DiscussionRoomDto.fromJson(topic));
      }

      return Success(dtos);
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
