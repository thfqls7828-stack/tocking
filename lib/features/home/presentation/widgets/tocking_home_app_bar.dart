import 'package:flutter/material.dart';

import '../../../../core/tocking_tokens.dart';
import 'tocking_search_action.dart';

class TockingHomeAppBar extends StatelessWidget {
  const TockingHomeAppBar({
    required this.logoAssetPath,
    required this.searchPlaceholder,
    super.key,
  });

  final String logoAssetPath;
  final String searchPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TockingSpacing.appBarPadding),
      child: Row(
        children: [
          Image.asset(
            logoAssetPath,
            width: TockingSizes.logo.width,
            height: TockingSizes.logo.height,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          TockingSearchAction(placeholder: searchPlaceholder),
        ],
      ),
    );
  }
}
