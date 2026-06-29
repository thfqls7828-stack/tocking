import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tocking_tokens.dart';
import '../daily_issue_panel/daily_issue_list_notifier.dart';

class TockingSearchAction extends ConsumerStatefulWidget {
  const TockingSearchAction({super.key});

  @override
  ConsumerState<TockingSearchAction> createState() =>
      _TockingSearchActionState();
}

class _TockingSearchActionState extends ConsumerState<TockingSearchAction> {
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchTap() {
    if (!_isExpanded) {
      setState(() => _isExpanded = true);
      return;
    }

    ref
        .read(dailyIssueListProvider.notifier)
        .submitSearch(_searchController.text);
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth =
        MediaQuery.sizeOf(context).width - (TockingSpacing.appBarPadding * 2);
    final expandedWidth = math.min(
      TockingSizes.searchExpandedWidth,
      math.max(TockingSizes.searchCollapsedWidth, availableWidth),
    );
    final width = _isExpanded
        ? expandedWidth
        : TockingSizes.searchCollapsedWidth;

    return AnimatedContainer(
      key: const Key('home-search-action'),
      duration: _isExpanded
          ? TockingMotion.searchTransition
          : TockingMotion.searchReverseTransition,
      curve: _isExpanded ? Curves.easeOutCubic : Curves.easeInOutCubic,
      alignment: Alignment.centerRight,
      width: width,
      height: TockingSizes.searchHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: TockingColors.searchFill,
          borderRadius: BorderRadius.circular(TockingRadii.search),
          border: Border.all(color: TockingColors.searchBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TockingRadii.search),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                InkWell(
                  key: _isExpanded
                      ? const Key('home-search-expanded-icon-button')
                      : const Key('home-search-collapsed-button'),
                  onTap: _handleSearchTap,
                  borderRadius: BorderRadius.circular(TockingRadii.search),
                  child: const SizedBox(
                    key: Key('home-search-icon-box'),
                    width: TockingSizes.searchIconBox,
                    height: TockingSizes.searchIconBox,
                    child: Icon(
                      Icons.search,
                      color: TockingColors.searchIcon,
                      size: TockingSizes.searchIcon,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRect(
                    child: AnimatedOpacity(
                      key: const Key('home-search-placeholder-opacity'),
                      opacity: _isExpanded ? 1 : 0,
                      duration: _isExpanded
                          ? TockingMotion.searchContentTransition
                          : TockingMotion.searchContentReverseTransition,
                      curve: _isExpanded
                          ? Curves.easeOutCubic
                          : Curves.easeInOutCubic,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: TockingSpacing.searchGap,
                        ),
                        child: FittedBox(
                          alignment: Alignment.center,
                          child: Text(
                            '검색어를 입력해주세요.',
                            key: const Key('home-search-placeholder'),
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: TockingColors.searchText,
                                  fontSize: TockingSizes.searchTextSize,
                                  height: 1,
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                      ),
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
