import 'package:flutter/material.dart';

import '../../../../core/theme/tocking_tokens.dart';
import '../../../../domain/debate/entity/debate_room_entity.dart';

class DailyIssuePanel extends StatelessWidget {
  const DailyIssuePanel({
    super.key,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  static const int _maxVisibleItems = 10;

  final List<DebateRoomEntity> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

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
            _DailyIssueHeader(),
            const SizedBox(height: TockingSpacing.dailyIssueHeaderGap),
            Expanded(
              child: _DailyIssueBody(
                items: visibleItems,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onRetry: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyIssueBody extends StatelessWidget {
  const _DailyIssueBody({
    required this.items,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final List<DebateRoomEntity> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const _DailyIssueLoadingState();
    }

    if (errorMessage != null && items.isEmpty) {
      return _DailyIssueErrorState(message: errorMessage!, onRetry: onRetry);
    }

    if (items.isEmpty) {
      return const _DailyIssueEmptyState();
    }

    return Column(
      children: [
        if (isLoading) ...[
          const LinearProgressIndicator(
            minHeight: 2,
            color: TockingColors.primary,
            backgroundColor: TockingColors.dailyIssueDivider,
          ),
          const SizedBox(height: TockingSpacing.dailyIssueInlineGap),
        ],
        Expanded(
          child: ListView.separated(
            key: const Key('home-daily-issue-list'),
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(
              height: TockingSpacing.dailyIssueSeparatorHeight,
              thickness: TockingSpacing.dailyIssueSeparatorHeight,
              color: TockingColors.dailyIssueDivider,
            ),
            itemBuilder: (context, index) => _DailyIssueTile(
              key: Key('home-daily-issue-item-$index'),
              item: items[index],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyIssueHeader extends StatelessWidget {
  const _DailyIssueHeader();

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
            ],
          ),
          const SizedBox(height: TockingSpacing.dailyIssueVoteOptionGap),
          _DailyIssueVotePreview(item: item),
        ],
      ),
    );
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
              label: item.proName,
              percent: item.proPercent,
              isPrimary: true,
            ),
            const SizedBox(height: TockingSpacing.dailyIssueVoteOptionGap),
            _DailyIssueStanceRow(
              label: item.conName,
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

class _DailyIssueLoadingState extends StatelessWidget {
  const _DailyIssueLoadingState();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 56) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: TockingColors.primary,
              ),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: TockingColors.primary,
                ),
              ),
              const SizedBox(height: TockingSpacing.dailyIssueInlineGap),
              Text(
                '토론방을 불러오는 중입니다.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TockingColors.dailyIssueMeta,
                  fontSize: TockingSizes.dailyIssueEmptyTextSize,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DailyIssueStatusScrollView extends StatelessWidget {
  const _DailyIssueStatusScrollView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _DailyIssueErrorState extends StatelessWidget {
  const _DailyIssueErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final messageStyle = textTheme.bodyMedium?.copyWith(
      color: TockingColors.dailyIssueMeta,
      fontSize: TockingSizes.dailyIssueEmptyTextSize,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 56) {
          return Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: messageStyle,
            ),
          );
        }

        return _DailyIssueStatusScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: TockingColors.dailyIssueMeta,
                size: 28,
              ),
              const SizedBox(height: TockingSpacing.dailyIssueInlineGap),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: messageStyle,
              ),
              const SizedBox(height: TockingSpacing.dailyIssueInlineGap),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        );
      },
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
