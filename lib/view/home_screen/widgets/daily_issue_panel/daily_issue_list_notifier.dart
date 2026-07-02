import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/data/debate_room_repository_provider.dart';
import '../../../../domain/debate/entity/debate_room_entity.dart';

part 'daily_issue_list_notifier.g.dart';

class DailyIssueListState {
  const DailyIssueListState({
    this.submittedSearchQuery = '',
    this.allItems = const [],
  });

  final String submittedSearchQuery;
  final List<DebateRoomEntity> allItems;

  List<DebateRoomEntity> get items {
    return _visibleItems(_filteredItems(allItems, submittedSearchQuery));
  }

  bool get isEmpty => items.isEmpty;

  DailyIssueListState copyWith({
    String? submittedSearchQuery,
    List<DebateRoomEntity>? allItems,
  }) {
    return DailyIssueListState(
      submittedSearchQuery: submittedSearchQuery ?? this.submittedSearchQuery,
      allItems: allItems ?? this.allItems,
    );
  }
}

@riverpod
class DailyIssueListNotifier extends _$DailyIssueListNotifier {
  @override
  Future<DailyIssueListState> build() {
    return _fetchDailyIssueRooms(baseState: const DailyIssueListState());
  }

  void submitSearch(String query) {
    final trimmedQuery = query.trim();
    state = state.whenData(
      (value) => value.copyWith(submittedSearchQuery: trimmedQuery),
    );
  }

  Future<void> refresh() async {
    final previousState = state.value ?? const DailyIssueListState();
    state = const AsyncLoading<DailyIssueListState>();

    state = await AsyncValue.guard(
      () => _fetchDailyIssueRooms(baseState: previousState),
    );
  }

  Future<DailyIssueListState> _fetchDailyIssueRooms({
    required DailyIssueListState baseState,
  }) async {
    final repository = ref.read(debateRoomRepositoryProvider);
    final result = await repository.fetchDailyIssueRooms();

    return result.when(
      success: (rooms) {
        return baseState.copyWith(allItems: rooms);
      },
      failure: (failure) {
        throw failure;
      },
    );
  }
}

List<DebateRoomEntity> _filteredItems(
  List<DebateRoomEntity> items,
  String query,
) {
  if (query.isEmpty) {
    return items;
  }

  final normalizedQuery = query.toLowerCase();
  return items
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

const int _maxDailyIssueCount = 10;
