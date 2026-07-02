import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/core/di/data/discussion_remote_data_source_provider.dart';
import 'package:tocking/core/error/result.dart';
import 'package:tocking/core/network/api_client.dart';

const bool _runManualApiTest = bool.fromEnvironment('RUN_MANUAL_API_TEST');
const String _manualSkipReason =
    'Manual network probe. Run with '
    '--dart-define=RUN_MANUAL_API_TEST=true when checking the real API.';

void main() {
  group('discussion roomList API manual probe', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'prints the category roomList response shape',
      () async {
        final apiClient = container.read(apiClientProvider);
        final dataSource = container.read(discussionRemoteDataSourceProvider);

        await _printRawRoomListResponseShape(
          apiClient: apiClient,
          label: 'category=사회',
          queryParameters: const {
            'pageNo': 1,
            'pagePerCnt': 10,
            'category': '사회',
          },
        );

        final result = await dataSource.fetchRoomListByCategory(
          category: '사회',
          pageNo: 1,
          pagePerCnt: 10,
        );

        _printParsedResultShape('category=사회', result);
      },
      skip: _runManualApiTest ? false : _manualSkipReason,
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test(
      'prints the keyword suggest response shape',
      () async {
        final apiClient = container.read(apiClientProvider);
        final dataSource = container.read(discussionRemoteDataSourceProvider);

        await _printRawSuggestResponseShape(
          apiClient: apiClient,
          label: 'keyword=신상공개',
          data: const {'keyword': '신상공개'},
        );

        final result = await dataSource.searchRoomListByKeyword(
          keyword: '신상공개',
        );

        _printParsedResultShape('keyword=신상공개', result);
      },
      skip: _runManualApiTest ? false : _manualSkipReason,
      timeout: const Timeout(Duration(seconds: 20)),
    );
  });
}

Future<void> _printRawRoomListResponseShape({
  required ApiClient apiClient,
  required String label,
  required Map<String, dynamic> queryParameters,
}) async {
  final response = await apiClient.get<Object>(
    '/api/discussion/roomList',
    queryParameters: queryParameters,
  );
  final data = response.data;

  debugPrint('[$label] statusCode: ${response.statusCode}');
  debugPrint('[$label] response runtimeType: ${data.runtimeType}');
  _debugJsonStructure(label, data);

  if (data is Map) {
    debugPrint('[$label] top-level keys: ${data.keys.toList()}');
  }
}

Future<void> _printRawSuggestResponseShape({
  required ApiClient apiClient,
  required String label,
  required Map<String, dynamic> data,
}) async {
  final response = await apiClient.post<Object>(
    '/api/discussion/suggest',
    data: data,
  );
  final responseData = response.data;

  debugPrint('[$label] statusCode: ${response.statusCode}');
  debugPrint('[$label] response runtimeType: ${responseData.runtimeType}');
  _debugJsonStructure(label, responseData);

  if (responseData is Map) {
    debugPrint('[$label] top-level keys: ${responseData.keys.toList()}');
  }
}

void _printParsedResultShape(String label, Result<dynamic> result) {
  result.when(
    success: (dto) {
      final roomJsonList = dto.roomJsonList;
      debugPrint('[$label] parsed room count: ${roomJsonList.length}');

      if (roomJsonList.isEmpty) {
        return;
      }

      final firstRoom = roomJsonList.first;
      debugPrint('[$label] first room keys: ${firstRoom.keys.toList()}');
      debugPrint('[$label] first room value types: ${_valueTypes(firstRoom)}');
    },
    failure: (failure) {
      debugPrint(
        '[$label] failure: ${failure.type} / ${failure.message} '
        'statusCode=${failure.statusCode}',
      );
    },
  );
}

Map<String, String> _valueTypes(Map<String, dynamic> json) {
  return json.map((key, value) => MapEntry(key, value.runtimeType.toString()));
}

void _debugJsonStructure(String label, Object? data) {
  debugPrint('[$label] JSON shape:');
  _debugLongText(_jsonShape(data));

  final firstRoom = _firstRoomJson(data);
  if (firstRoom == null) {
    debugPrint('[$label] first room sample: <not found>');
    return;
  }

  debugPrint('[$label] first room sample:');
  _debugLongText(const JsonEncoder.withIndent('  ').convert(firstRoom));
}

String _jsonShape(Object? value, {int depth = 0}) {
  final indent = '  ' * depth;

  if (value is Map) {
    if (value.isEmpty) {
      return '${indent}Map<String, dynamic> {}';
    }

    final buffer = StringBuffer('${indent}Map<String, dynamic> {');
    for (final entry in value.entries) {
      buffer
        ..writeln()
        ..write('$indent  "${entry.key}": ')
        ..write(_jsonShape(entry.value, depth: depth + 1).trimLeft());
    }
    buffer
      ..writeln()
      ..write('$indent}');
    return buffer.toString();
  }

  if (value is List) {
    if (value.isEmpty) {
      return '${indent}List<dynamic> []';
    }

    return '${indent}List<dynamic> length=${value.length} [\n'
        '${_jsonShape(value.first, depth: depth + 1)}\n'
        '$indent]';
  }

  return '$indent${value.runtimeType}';
}

Map<String, dynamic>? _firstRoomJson(Object? data) {
  if (data is List) {
    for (final item in data) {
      final itemJson = _asJsonMap(item);
      if (itemJson != null) {
        return itemJson;
      }

      final nestedJson = _firstRoomJson(item);
      if (nestedJson != null) {
        return nestedJson;
      }
    }

    return null;
  }

  if (data is! Map) {
    return null;
  }

  for (final key in const ['data', 'list', 'items', 'content', 'roomList']) {
    final firstRoom = _firstRoomJson(data[key]);
    if (firstRoom != null) {
      return firstRoom;
    }
  }

  for (final value in data.values) {
    final firstRoom = _firstRoomJson(value);
    if (firstRoom != null) {
      return firstRoom;
    }
  }

  return null;
}

Map<String, dynamic>? _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return null;
}

void _debugLongText(String text) {
  for (final line in text.split('\n')) {
    debugPrint(line);
  }
}
