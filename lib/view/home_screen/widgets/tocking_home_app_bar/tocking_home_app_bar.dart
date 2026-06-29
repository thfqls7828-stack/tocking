import 'package:flutter/material.dart';

import '../../../../core/theme/tocking_tokens.dart';
import '../tocking_search_action/tocking_search_action.dart';

class TockingHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TockingHomeAppBar({super.key});

  static const String _logoAssetPath = 'assets/logo/logo-row.png';

  @override
  Size get preferredSize => const Size.fromHeight(TockingSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: TockingColors.canvas,
      surfaceTintColor: TockingColors.canvas,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: TockingSizes.appBarHeight,
      centerTitle: false,
      titleSpacing: TockingSpacing.appBarPadding,
      shape: const Border(
        bottom: BorderSide(color: TockingColors.appBarBorder),
      ),
      title: Image.asset(
        _logoAssetPath,
        key: const ValueKey('home-app-bar-logo'),
        width: TockingSizes.logo.width,
        height: TockingSizes.logo.height,
        fit: BoxFit.contain,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: TockingSpacing.appBarPadding),
          child: const TockingSearchAction(),
        ),
      ],
    );
  }
}
