import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_search_notifier.g.dart';

class HomeSearchState {
  const HomeSearchState({required this.isFocused});

  final bool isFocused;

  HomeSearchState copyWith({bool? isFocused}) {
    return HomeSearchState(isFocused: isFocused ?? this.isFocused);
  }
}

@riverpod
class HomeSearchNotifier extends _$HomeSearchNotifier {
  @override
  HomeSearchState build() {
    return const HomeSearchState(isFocused: false);
  }

  void setFocused(bool isFocused) {
    state = state.copyWith(isFocused: isFocused);
  }
}
