import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/data/debate/dto/discussion_room_list_response_dto.dart';

void main() {
  group('DiscussionRoomListResponseDto', () {
    test('converts a wrapped room list response into JSON maps', () {
      final dto = DiscussionRoomListResponseDto.fromResponseData({
        'data': [
          {'roomId': 1, 'title': '신상공개 찬반'},
          {'roomId': 2, 'title': '민초 찬반'},
        ],
      });

      expect(dto.roomJsonList, hasLength(2));
      expect(dto.roomJsonList.first['roomId'], 1);
      expect(dto.roomJsonList.first['title'], '신상공개 찬반');
    });

    test('converts a raw room list response into JSON maps', () {
      final dto = DiscussionRoomListResponseDto.fromResponseData([
        {'roomId': 1, 'title': '신상공개 찬반'},
      ]);

      expect(dto.roomJsonList, [
        {'roomId': 1, 'title': '신상공개 찬반'},
      ]);
    });

    test('normalizes non-string map keys to string keys', () {
      final dto = DiscussionRoomListResponseDto.fromResponseData({
        'data': [
          {1: 'room-id', 'title': '신상공개 찬반'},
        ],
      });

      expect(dto.roomJsonList.first['1'], 'room-id');
      expect(dto.roomJsonList.first['title'], '신상공개 찬반');
    });
  });
}
