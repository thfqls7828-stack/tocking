import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/tocking_tokens.dart';
import '../notifiers/home_search_notifier.dart';

class TockingSearchAction extends ConsumerWidget {
  const TockingSearchAction({required this.placeholder, super.key});

  final String placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(homeSearchProvider);
    final borderColor = searchState.isFocused
        ? TockingColors.searchFocusedBorder
        : TockingColors.searchBorder;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TockingSizes.searchMaxWidth),
      child: SizedBox(
        height: TockingSizes.searchHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: TockingColors.searchFill,
            borderRadius: BorderRadius.circular(TockingRadii.search),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  key: Key('home-search-icon-box'),
                  width: TockingSizes.searchIcon,
                  height: TockingSizes.searchIcon,
                  child: Icon(
                    Icons.search,
                    color: TockingColors.searchIcon,
                    size: TockingSizes.searchIcon,
                  ),
                ),
                const SizedBox(width: TockingSpacing.searchGap),
                Flexible(
                  child: Text(
                    placeholder,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: TockingColors.searchText,
                      fontSize: 16,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
