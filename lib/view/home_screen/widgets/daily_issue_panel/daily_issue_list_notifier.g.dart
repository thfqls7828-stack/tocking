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
    extends
        $AsyncNotifierProvider<DailyIssueListNotifier, DailyIssueListState> {
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
}

String _$dailyIssueListNotifierHash() =>
    r'3a96cf56e568c8435ce47cf11a86ff4b5076df7e';

abstract class _$DailyIssueListNotifier
    extends $AsyncNotifier<DailyIssueListState> {
  FutureOr<DailyIssueListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DailyIssueListState>, DailyIssueListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DailyIssueListState>, DailyIssueListState>,
              AsyncValue<DailyIssueListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
