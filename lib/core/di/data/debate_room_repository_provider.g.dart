// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debate_room_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(debateRoomRepository)
final debateRoomRepositoryProvider = DebateRoomRepositoryProvider._();

final class DebateRoomRepositoryProvider
    extends
        $FunctionalProvider<
          DebateRoomRepository,
          DebateRoomRepository,
          DebateRoomRepository
        >
    with $Provider<DebateRoomRepository> {
  DebateRoomRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debateRoomRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debateRoomRepositoryHash();

  @$internal
  @override
  $ProviderElement<DebateRoomRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DebateRoomRepository create(Ref ref) {
    return debateRoomRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebateRoomRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebateRoomRepository>(value),
    );
  }
}

String _$debateRoomRepositoryHash() =>
    r'945a83115ba8c8f0cfdfbe59a48605f5482f8e6b';
