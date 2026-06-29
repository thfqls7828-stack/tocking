import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

class HomeViewState {
  const HomeViewState({this.submittedSearchQuery});

  final String? submittedSearchQuery;

  bool get hasSubmittedSearch => submittedSearchQuery != null;
  bool get hasActiveSearch => submittedSearchQuery?.isNotEmpty ?? false;
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  @override
  HomeViewState build() {
    return const HomeViewState();
  }

  void submitSearch(String query) {
    state = HomeViewState(submittedSearchQuery: query.trim());
  }
}
