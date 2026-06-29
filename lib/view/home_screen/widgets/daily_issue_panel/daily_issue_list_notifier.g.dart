// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_issue_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DailyIssueListNotifier)
final dailyIssueListProvider = DailyIssueListNotifierProvider._();

final class DailyIssueListNotifierProvider
    extends $NotifierProvider<DailyIssueListNotifier, DailyIssueListState> {
  DailyIssueListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyIssueListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyIssueListNotifierHash();

  @$internal
  @override
  DailyIssueListNotifier create() => DailyIssueListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyIssueListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyIssueListState>(value),
    );
  }
}

String _$dailyIssueListNotifierHash() =>
    r'7ce1980dbb05b0a134c9c96adc9860bf8f90ea8b';

abstract class _$DailyIssueListNotifier extends $Notifier<DailyIssueListState> {
  DailyIssueListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DailyIssueListState, DailyIssueListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DailyIssueListState, DailyIssueListState>,
              DailyIssueListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
