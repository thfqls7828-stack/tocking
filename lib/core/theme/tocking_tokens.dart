import 'package:flutter/material.dart';

abstract final class TockingColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color pageBackground = Color(0xFFF5F7FF);
  static const Color appBarBorder = Color(0xFFE7E7EA);
  static const Color animationPlaceholderStart = Color(0xFFC8D9E9);
  static const Color animationPlaceholderEnd = Color(0xFF9DB4CA);
  static const Color rulesPill = Color(0xFF0B4778);
  static const Color rulesGuideCard = Color(0xFFFFFFFF);
  static const Color rulesGuideText = Color(0xFF303030);
  static const Color rulesGuideSubText = Color(0xFF666666);
  static const Color rulesGuideIcon = Color(0xFF777777);
  static const Color rulesGuideShadow = Color(0x33000000);
  static const Color dailyIssuePanel = Color(0xFFFFFFFF);
  static const Color dailyIssueTitle = Color(0xFF303030);
  static const Color dailyIssueText = Color(0xFF303030);
  static const Color dailyIssueMeta = Color(0xFF74777D);
  static const Color dailyIssueDivider = Color(0xFFEFF1F5);
  static const Color dailyIssueCategoryPill = Color(0xFFFF5A58);
  static const Color dailyIssueVotePreview = Color(0xFFDFF0FF);
  static const Color dailyIssueVoteTrack = Color(0xFFEAF6FF);
  static const Color dailyIssueVoteFill = Color(0xFF2B93E8);
  static const Color dailyIssueOptionPrimary = Color(0xFF82EF9A);
  static const Color dailyIssueOptionSecondary = Color(0xFFFFCE82);
  static const Color searchFill = Color(0xFFF4F4F5);
  static const Color searchBorder = Color(0xFFE9E9EC);
  static const Color searchIcon = Color(0xFF9B9BA1);
  static const Color searchText = Color(0xFF6E6E73);
  static const Color onDark = Color(0xFFFFFFFF);
}

abstract final class TockingSpacing {
  static const double appFrameWidth = 720;
  static const double appFrameHeight = 828;
  static const double appBarPadding = 12;
  static const double bodyPadding = 16;
  static const double searchGap = 10;
  static const double rulesPillHorizontalPadding = 12;
  static const double rulesPillVerticalPadding = 4;
  static const double rulesGuideArrowLeft = 42;
  static const double rulesGuideArrowTop = 48;
  static const double rulesGuideHorizontalInset = 20;
  static const double rulesGuideTop = 54;
  static const double rulesGuideBottom = 18;
  static const double rulesGuidePadding = 20;
  static const double rulesGuideTitleGap = 8;
  static const double rulesGuideBulletGap = 7;
  static const double rulesGuideBulletDotWidth = 18;
  static const double heroToDailyIssueGap = 16;
  static const double dailyIssuePanelPadding = 16;
  static const double dailyIssueHeaderGap = 12;
  static const double dailyIssueItemVerticalPadding = 12;
  static const double dailyIssueItemHorizontalPadding = 2;
  static const double dailyIssueInlineGap = 8;
  static const double dailyIssueMetaGap = 6;
  static const double dailyIssueVotePadding = 8;
  static const double dailyIssueVoteOptionGap = 6;
  static const double dailyIssueVoteOptionIconGap = 4;
  static const double dailyIssueVoteBarGap = 8;
  static const double dailyIssueSeparatorHeight = 1;
}

abstract final class TockingSizes {
  static const Size logo = Size(166.5, 36);
  static const Size animationPlaceholder = Size(688, 387);
  static const double appBarHeight = 60;
  static const double searchCollapsedWidth = 36;
  static const double searchExpandedWidth = 140;
  static const double searchIconBox = 36;
  static const double searchIcon = 24;
  static const double searchExpandedIconTapWidth = 36;
  static const double searchHeight = 36;
  static const double searchTextSize = 16;
  static const double rulesPillTextSize = 14.5;
  static const double rulesGuideArrow = 18;
  static const double rulesGuideIcon = 22;
  static const double rulesGuideTitleTextSize = 18;
  static const double rulesGuideBodyTextSize = 12.5;
  static const double rulesGuideDetailTextSize = 12;
  static const double rulesGuideContentWidth = 608;
  static const double dailyIssueHeaderIcon = 20;
  static const double dailyIssueHeaderTextSize = 20;
  static const double dailyIssueCountTextSize = 12;
  static const double dailyIssueCategoryTextSize = 12;
  static const double dailyIssueCategoryHeight = 22;
  static const double dailyIssueTitleTextSize = 16;
  static const double dailyIssueMetaTextSize = 12;
  static const double dailyIssueVoteOptionWidth = 112;
  static const double dailyIssueVoteOptionHeight = 24;
  static const double dailyIssueVoteOptionIcon = 16;
  static const double dailyIssueVotePercentWidth = 42;
  static const double dailyIssueVoteBarHeight = 8;
  static const double dailyIssueEmptyTextSize = 14;
}

abstract final class TockingRadii {
  static const double animationPlaceholder = 12;
  static const double rulesPill = 11;
  static const double rulesGuide = 14;
  static const double search = 18;
  static const double dailyIssuePanel = 8;
  static const double dailyIssueCategoryPill = 11;
  static const double dailyIssueVotePreview = 8;
  static const double dailyIssueVoteOption = 12;
  static const double dailyIssueVoteBar = 4;
}

abstract final class TockingMotion {
  static const Duration searchTransition = Duration(milliseconds: 220);
  static const Duration searchReverseTransition = Duration(milliseconds: 280);
  static const Duration searchContentTransition = Duration(milliseconds: 160);
  static const Duration searchContentReverseTransition = Duration(
    milliseconds: 220,
  );
  static const Offset searchSlideOffset = Offset(0.16, 0);
}
