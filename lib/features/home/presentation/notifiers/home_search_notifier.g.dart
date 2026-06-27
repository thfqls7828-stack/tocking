// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeSearchNotifier)
final homeSearchProvider = HomeSearchNotifierProvider._();

final class HomeSearchNotifierProvider
    extends $NotifierProvider<HomeSearchNotifier, HomeSearchState> {
  HomeSearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSearchNotifierHash();

  @$internal
  @override
  HomeSearchNotifier create() => HomeSearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeSearchState>(value),
    );
  }
}

String _$homeSearchNotifierHash() =>
    r'801a3d3f4ee272336ab641b177eaa3deee28afff';

abstract class _$HomeSearchNotifier extends $Notifier<HomeSearchState> {
  HomeSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeSearchState, HomeSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeSearchState, HomeSearchState>,
              HomeSearchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
