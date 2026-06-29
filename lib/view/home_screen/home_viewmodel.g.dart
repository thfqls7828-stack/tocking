// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeViewmodel)
final homeViewmodelProvider = HomeViewmodelProvider._();

final class HomeViewmodelProvider
    extends $NotifierProvider<HomeViewmodel, HomeViewState> {
  HomeViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewmodelHash();

  @$internal
  @override
  HomeViewmodel create() => HomeViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeViewState>(value),
    );
  }
}

String _$homeViewmodelHash() => r'a46a564e46a985febe3ee57de5a10e3ac790300a';

abstract class _$HomeViewmodel extends $Notifier<HomeViewState> {
  HomeViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeViewState, HomeViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeViewState, HomeViewState>,
              HomeViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
