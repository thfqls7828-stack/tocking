import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/debate/entity/debate_room_entity.dart';

part 'daily_issue_list_notifier.g.dart';

class DailyIssueListState {
  const DailyIssueListState({this.submittedSearchQuery, required this.items});

  final String? submittedSearchQuery;
  final List<DebateRoomEntity> items;
}

@riverpod
class DailyIssueListNotifier extends _$DailyIssueListNotifier {
  @override
  DailyIssueListState build() {
    return DailyIssueListState(items: _visibleItems(_mockDebateRooms));
  }

  void submitSearch(String query) {
    final trimmedQuery = query.trim();
    state = DailyIssueListState(
      submittedSearchQuery: trimmedQuery,
      items: _visibleItems(_filteredItems(trimmedQuery)),
    );
  }

  List<DebateRoomEntity> _filteredItems(String query) {
    if (query.isEmpty) {
      return _mockDebateRooms;
    }

    final normalizedQuery = query.toLowerCase();
    return _mockDebateRooms
        .where((item) => _matchesQuery(item, normalizedQuery))
        .toList(growable: false);
  }

  List<DebateRoomEntity> _visibleItems(List<DebateRoomEntity> items) {
    return items.take(_maxDailyIssueCount).toList(growable: false);
  }

  bool _matchesQuery(DebateRoomEntity item, String normalizedQuery) {
    return item.category.toLowerCase().contains(normalizedQuery) ||
        item.title.toLowerCase().contains(normalizedQuery);
  }
}

const int _maxDailyIssueCount = 10;

const List<DebateRoomEntity> _mockDebateRooms = [
  DebateRoomEntity(
    id: 'daily-issue-1',
    category: '생활',
    title: '짬뽕이 VS 볶순이!!',
    proParticipantCount: 1,
    conParticipantCount: 0,
    remainingTime: Duration(hours: 1, minutes: 59),
  ),
  DebateRoomEntity(
    id: 'daily-issue-2',
    category: '취향',
    title: '민초파 VS 반민초파!!',
    proParticipantCount: 1,
    conParticipantCount: 0,
    remainingTime: Duration(hours: 1, minutes: 59),
  ),
  DebateRoomEntity(
    id: 'daily-issue-3',
    category: '생활',
    title: '계획형 VS 즉흥형!!',
    proParticipantCount: 4,
    conParticipantCount: 3,
    remainingTime: Duration(hours: 1, minutes: 44),
  ),
  DebateRoomEntity(
    id: 'daily-issue-4',
    category: '습관',
    title: '아침형 인간 VS 야행성 인간!!',
    proParticipantCount: 5,
    conParticipantCount: 7,
    remainingTime: Duration(hours: 1, minutes: 31),
  ),
  DebateRoomEntity(
    id: 'daily-issue-5',
    category: '관계',
    title: '약속은 일찍 도착 VS 딱 맞춰 도착!!',
    proParticipantCount: 5,
    conParticipantCount: 3,
    remainingTime: Duration(hours: 1, minutes: 18),
  ),
  DebateRoomEntity(
    id: 'daily-issue-6',
    category: '음식',
    title: '탕수육은 부먹 VS 찍먹!!',
    proParticipantCount: 7,
    conParticipantCount: 8,
    remainingTime: Duration(hours: 1, minutes: 5),
  ),
  DebateRoomEntity(
    id: 'daily-issue-7',
    category: '관계',
    title: '메시지 답장 바로 VS 몰아서!!',
    proParticipantCount: 3,
    conParticipantCount: 3,
    remainingTime: Duration(minutes: 54),
  ),
  DebateRoomEntity(
    id: 'daily-issue-8',
    category: '습관',
    title: '운동은 아침 VS 저녁!!',
    proParticipantCount: 3,
    conParticipantCount: 6,
    remainingTime: Duration(minutes: 42),
  ),
  DebateRoomEntity(
    id: 'daily-issue-9',
    category: '취향',
    title: '커피는 아이스 VS 따뜻한!!',
    proParticipantCount: 8,
    conParticipantCount: 3,
    remainingTime: Duration(minutes: 29),
  ),
  DebateRoomEntity(
    id: 'daily-issue-10',
    category: '여행',
    title: '여행은 맛집 VS 풍경!!',
    proParticipantCount: 3,
    conParticipantCount: 2,
    remainingTime: Duration(minutes: 16),
  ),
];
