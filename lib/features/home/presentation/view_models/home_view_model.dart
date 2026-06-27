import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

class HomeViewState {
  const HomeViewState({
    required this.logoAssetPath,
    required this.searchPlaceholder,
  });

  final String logoAssetPath;
  final String searchPlaceholder;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeViewState build() {
    return const HomeViewState(
      logoAssetPath: 'assets/logo/logo-row.png',
      searchPlaceholder: '검색어를 입력해주세요.',
    );
  }
}
