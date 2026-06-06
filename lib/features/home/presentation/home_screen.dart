import 'package:flutter/material.dart';

import '../../../core/tocking_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: TockingSpacing.appFrameWidth,
            height: TockingSpacing.appFrameHeight,
            child: Column(
              children: [
                TockingHomeAppBar(),
                Expanded(child: SizedBox.expand()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TockingHomeAppBar extends StatelessWidget {
  const TockingHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TockingSpacing.appBarPadding),
      child: Row(
        children: [
          Image.asset(
            'assets/logo/logo-row.png',
            width: TockingSizes.logo.width,
            height: TockingSizes.logo.height,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          const TockingSearchAction(),
        ],
      ),
    );
  }
}

class TockingSearchAction extends StatelessWidget {
  const TockingSearchAction({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TockingSizes.searchMaxWidth),
      child: SizedBox(
        height: TockingSizes.searchHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: TockingColors.searchFill,
            borderRadius: BorderRadius.circular(TockingRadii.search),
            border: Border.all(color: TockingColors.searchBorder),
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
                    '검색어를 입력해주세요.',
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
