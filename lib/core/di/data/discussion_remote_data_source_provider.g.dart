// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_remote_data_source_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discussionRemoteDataSource)
final discussionRemoteDataSourceProvider =
    DiscussionRemoteDataSourceProvider._();

final class DiscussionRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          DiscussionRemoteDataSource,
          DiscussionRemoteDataSource,
          DiscussionRemoteDataSource
        >
    with $Provider<DiscussionRemoteDataSource> {
  DiscussionRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discussionRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discussionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DiscussionRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscussionRemoteDataSource create(Ref ref) {
    return discussionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscussionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscussionRemoteDataSource>(value),
    );
  }
}

String _$discussionRemoteDataSourceHash() =>
    r'c116d78538b23614631f0c924cb4a29ddaa2e77e';
