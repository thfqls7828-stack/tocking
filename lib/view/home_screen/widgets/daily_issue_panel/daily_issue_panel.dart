import 'package:flutter/material.dart';

import '../../../../core/theme/tocking_tokens.dart';
import '../../../../domain/debate/entity/debate_room_entity.dart';

class DailyIssuePanel extends StatelessWidget {
  const DailyIssuePanel({super.key, required this.items});

  static const int _maxVisibleItems = 10;

  final List<DebateRoomEntity> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.length > _maxVisibleItems
        ? items.take(_maxVisibleItems).toList(growable: false)
        : items;

    return DecoratedBox(
      key: const Key('home-daily-issue-panel'),
      decoration: BoxDecoration(
        color: TockingColors.dailyIssuePanel,
        borderRadius: BorderRadius.circular(TockingRadii.dailyIssuePanel),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TockingSpacing.dailyIssuePanelPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DailyIssueHeader(count: visibleItems.length),
            const SizedBox(height: TockingSpacing.dailyIssueHeaderGap),
            Expanded(
              child: visibleItems.isEmpty
                  ? const _DailyIssueEmptyState()
                  : ListView.separated(
                      key: const Key('home-daily-issue-list'),
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemCount: visibleItems.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: TockingSpacing.dailyIssueSeparatorHeight,
                        thickness: TockingSpacing.dailyIssueSeparatorHeight,
                        color: TockingColors.dailyIssueDivider,
                      ),
                      itemBuilder: (context, index) => _DailyIssueTile(
                        key: Key('home-daily-issue-item-$index'),
                        item: visibleItems[index],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyIssueHeader extends StatelessWidget {
  const _DailyIssueHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const Icon(
          Icons.campaign,
          color: TockingColors.dailyIssueMeta,
          size: TockingSizes.dailyIssueHeaderIcon,
        ),
        const SizedBox(width: TockingSpacing.dailyIssueMetaGap),
        Expanded(
          child: Text(
            '일상의 쟁점',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              color: TockingColors.dailyIssueTitle,
              fontSize: TockingSizes.dailyIssueHeaderTextSize,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          '$count개',
          style: textTheme.bodySmall?.copyWith(
            color: TockingColors.dailyIssueMeta,
            fontSize: TockingSizes.dailyIssueCountTextSize,
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _DailyIssueTile extends StatelessWidget {
  const _DailyIssueTile({super.key, required this.item});

  final DebateRoomEntity item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TockingSpacing.dailyIssueItemHorizontalPadding,
        vertical: TockingSpacing.dailyIssueItemVerticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DailyIssueCategoryPill(label: item.category),
              const SizedBox(width: TockingSpacing.dailyIssueInlineGap),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: TockingColors.dailyIssueText,
                    fontSize: TockingSizes.dailyIssueTitleTextSize,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TockingSpacing.dailyIssueInlineGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  '의견별 지지도 현황(토론 참여자 : ${item.participantCount})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: TockingColors.dailyIssueMeta,
                    fontSize: TockingSizes.dailyIssueMetaTextSize,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const Icon(
                Icons.schedule,
                color: TockingColors.dailyIssueMeta,
                size: TockingSizes.dailyIssueMetaTextSize,
              ),
              const SizedBox(width: 2),
              Text(
                _formatRemainingTime(item.remainingTime),
                style: textTheme.bodySmall?.copyWith(
                  color: TockingColors.dailyIssueMeta,
                  fontSize: TockingSizes.dailyIssueMetaTextSize,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: TockingSpacing.dailyIssueVoteOptionGap),
          _DailyIssueVotePreview(item: item),
        ],
      ),
    );
  }

  String _formatRemainingTime(Duration remainingTime) {
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);

    if (hours == 0) {
      return '$minutes분 남음';
    }

    return '$hours시간 $minutes분 남음';
  }
}

class _DailyIssueCategoryPill extends StatelessWidget {
  const _DailyIssueCategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: TockingSizes.dailyIssueCategoryHeight,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: TockingColors.dailyIssueCategoryPill,
          borderRadius: BorderRadius.circular(
            TockingRadii.dailyIssueCategoryPill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              '# $label',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: TockingColors.onDark,
                fontSize: TockingSizes.dailyIssueCategoryTextSize,
                fontWeight: FontWeight.w800,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyIssueVotePreview extends StatelessWidget {
  const _DailyIssueVotePreview({required this.item});

  final DebateRoomEntity item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: TockingColors.dailyIssueVotePreview,
        borderRadius: BorderRadius.circular(TockingRadii.dailyIssueVotePreview),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TockingSpacing.dailyIssueVotePadding),
        child: Column(
          children: [
            _DailyIssueStanceRow(
              label: '찬성',
              percent: item.proPercent,
              isPrimary: true,
            ),
            const SizedBox(height: TockingSpacing.dailyIssueVoteOptionGap),
            _DailyIssueStanceRow(
              label: '반대',
              percent: item.conPercent,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyIssueStanceRow extends StatelessWidget {
  const _DailyIssueStanceRow({
    required this.label,
    required this.percent,
    required this.isPrimary,
  });

  final String label;
  final int percent;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final normalizedPercent = percent.clamp(0, 100);

    return Row(
      children: [
        SizedBox(
          width: TockingSizes.dailyIssueVoteOptionWidth,
          height: TockingSizes.dailyIssueVoteOptionHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isPrimary
                  ? TockingColors.dailyIssueOptionPrimary
                  : TockingColors.dailyIssueOptionSecondary,
              borderRadius: BorderRadius.circular(
                TockingRadii.dailyIssueVoteOption,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.record_voice_over,
                    color: TockingColors.dailyIssueMeta,
                    size: TockingSizes.dailyIssueVoteOptionIcon,
                  ),
                  const SizedBox(
                    width: TockingSpacing.dailyIssueVoteOptionIconGap,
                  ),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: TockingColors.dailyIssueText,
                        fontSize: TockingSizes.dailyIssueMetaTextSize,
                        fontWeight: FontWeight.w800,
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
        const SizedBox(width: TockingSpacing.dailyIssueVoteBarGap),
        Expanded(child: _DailyIssueVoteBar(percent: normalizedPercent)),
        SizedBox(
          width: TockingSizes.dailyIssueVotePercentWidth,
          child: Text(
            '$normalizedPercent%',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TockingColors.dailyIssueText,
              fontSize: TockingSizes.dailyIssueMetaTextSize,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyIssueVoteBar extends StatelessWidget {
  const _DailyIssueVoteBar({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TockingSizes.dailyIssueVoteBarHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TockingRadii.dailyIssueVoteBar),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: TockingColors.dailyIssueVoteTrack,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent / 100,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: TockingColors.dailyIssueVoteFill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyIssueEmptyState extends StatelessWidget {
  const _DailyIssueEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '표시할 쟁점이 없습니다.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: TockingColors.dailyIssueMeta,
          fontSize: TockingSizes.dailyIssueEmptyTextSize,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
