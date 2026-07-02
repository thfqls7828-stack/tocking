import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/core/error/app_failure.dart';
import 'package:tocking/core/error/result.dart';
import 'package:tocking/core/network/api_client.dart';
import 'package:tocking/data/debate/data_source/discussion_remote_data_source.dart';
import 'package:tocking/data/debate/dto/discussion_room_list_response_dto.dart';

void main() {
  group('DiscussionRemoteDataSource', () {
    test('fetches the room list by category with paging parameters', () async {
      final apiClient = _FakeApiClient(
        responseData: {
          'data': [
            {'roomId': 1, 'title': '사회 토론'},
          ],
        },
      );
      final dataSource = DiscussionRemoteDataSource(apiClient);

      final result = await dataSource.fetchRoomListByCategory(
        category: ' 사회 ',
        pageNo: 1,
        pagePerCnt: 10,
      );

      expect(apiClient.requestedPath, '/api/discussion/roomList');
      expect(apiClient.queryParameters, {
        'pageNo': 1,
        'pagePerCnt': 10,
        'category': '사회',
      });
      expect(result, isA<Success<DiscussionRoomListResponseDto>>());

      final success = result as Success<DiscussionRoomListResponseDto>;
      expect(success.data.roomJsonList.first['title'], '사회 토론');
    });

    test('searches the room list through the suggest endpoint', () async {
      final apiClient = _FakeApiClient(
        responseData: [
          {'roomId': 1, 'title': '신상공개 찬반'},
        ],
      );
      final dataSource = DiscussionRemoteDataSource(apiClient);

      final result = await dataSource.searchRoomListByKeyword(
        keyword: ' 신상공개 ',
      );

      expect(apiClient.requestedPath, '/api/discussion/suggest');
      expect(apiClient.requestData, {'keyword': '신상공개'});
      expect(result, isA<Success<DiscussionRoomListResponseDto>>());
    });

    test(
      'returns a parsing failure when the response shape is invalid',
      () async {
        final dataSource = DiscussionRemoteDataSource(
          _FakeApiClient(responseData: {'message': 'success'}),
        );

        final result = await dataSource.fetchRoomList();

        expect(result, isA<Failure<DiscussionRoomListResponseDto>>());

        final failure = result as Failure<DiscussionRoomListResponseDto>;
        expect(failure.error.type, AppFailureType.parsing);
      },
    );

    test(
      'returns a network failure when Dio reports a connection error',
      () async {
        final requestOptions = RequestOptions(path: '/api/discussion/roomList');
        final dataSource = DiscussionRemoteDataSource(
          _FakeApiClient(
            error: DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.connectionError,
            ),
          ),
        );

        final result = await dataSource.fetchRoomList();

        expect(result, isA<Failure<DiscussionRoomListResponseDto>>());

        final failure = result as Failure<DiscussionRoomListResponseDto>;
        expect(failure.error.type, AppFailureType.network);
      },
    );
  });
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient({this.responseData, this.error}) : super(Dio());

  final Object? responseData;
  final Object? error;

  String? requestedPath;
  Map<String, dynamic>? queryParameters;
  Object? requestData;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    requestedPath = path;
    this.queryParameters = queryParameters;

    final error = this.error;
    if (error != null) {
      throw error;
    }

    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: responseData as T?,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    requestedPath = path;
    requestData = data;
    this.queryParameters = queryParameters;

    final error = this.error;
    if (error != null) {
      throw error;
    }

    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: responseData as T?,
    );
  }
}
