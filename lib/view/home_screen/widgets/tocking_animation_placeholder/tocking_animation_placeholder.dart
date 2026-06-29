import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/tocking_tokens.dart';

class TockingAnimationPlaceholder extends StatefulWidget {
  const TockingAnimationPlaceholder({super.key});

  @override
  State<TockingAnimationPlaceholder> createState() =>
      _TockingAnimationPlaceholderState();
}

class _TockingAnimationPlaceholderState
    extends State<TockingAnimationPlaceholder> {
  static const String _animationAsset = 'assets/home/animation.mp4';
  static final Object _rulesTapRegion = Object();

  late final VideoPlayerController _animationController;
  late final Future<void> _animationFuture;
  final FocusNode _rulesFocusNode = FocusNode(debugLabel: 'home-rules-guide');
  bool _isRulesGuideVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = VideoPlayerController.asset(_animationAsset);
    _animationFuture = _prepareAnimation();
  }

  Future<void> _prepareAnimation() async {
    await _animationController.initialize();
    if (!mounted) {
      return;
    }

    await _animationController.setLooping(true);
    if (!mounted) {
      return;
    }

    await _animationController.setVolume(0);
    if (!mounted) {
      return;
    }

    try {
      await _animationController.play();
    } on PlatformException {
      // Keep the initialized frame visible if a platform rejects autoplay.
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rulesFocusNode.dispose();
    super.dispose();
  }

  void _handleRulesFocusChange(bool hasFocus) {
    if (!hasFocus && _isRulesGuideVisible) {
      setState(() => _isRulesGuideVisible = false);
    }
  }

  void _toggleRulesGuide() {
    if (_isRulesGuideVisible) {
      _hideRulesGuide();
      return;
    }

    setState(() => _isRulesGuideVisible = true);
    _rulesFocusNode.requestFocus();
  }

  void _hideRulesGuide() {
    if (!_isRulesGuideVisible) {
      return;
    }

    setState(() => _isRulesGuideVisible = false);
    _rulesFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _rulesFocusNode,
      onFocusChange: _handleRulesFocusChange,
      child: ClipRRect(
        key: const Key('home-animation-placeholder'),
        borderRadius: BorderRadius.circular(TockingRadii.animationPlaceholder),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TockingColors.animationPlaceholderStart,
                TockingColors.animationPlaceholderEnd,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: FutureBuilder<void>(
                  future: _animationFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done ||
                        snapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    return _AnimationVideo(controller: _animationController);
                  },
                ),
              ),
              if (_isRulesGuideVisible)
                Positioned.fill(
                  child: GestureDetector(
                    key: const Key('home-rules-guide-outside-tap-layer'),
                    behavior: HitTestBehavior.translucent,
                    onTap: _hideRulesGuide,
                  ),
                ),
              Positioned(
                left: TockingSpacing.bodyPadding,
                top: 10,
                child: TapRegion(
                  groupId: _rulesTapRegion,
                  enabled: _isRulesGuideVisible,
                  onTapOutside: (_) => _hideRulesGuide(),
                  child: _RulesPill(
                    isGuideVisible: _isRulesGuideVisible,
                    onTap: _toggleRulesGuide,
                  ),
                ),
              ),
              if (_isRulesGuideVisible) ...[
                Positioned(
                  left: TockingSpacing.rulesGuideArrowLeft,
                  top: TockingSpacing.rulesGuideArrowTop,
                  child: TapRegion(
                    groupId: _rulesTapRegion,
                    child: const _RulesGuideArrow(),
                  ),
                ),
                Positioned(
                  left: TockingSpacing.rulesGuideHorizontalInset,
                  right: TockingSpacing.rulesGuideHorizontalInset,
                  top: TockingSpacing.rulesGuideTop,
                  bottom: TockingSpacing.rulesGuideBottom,
                  child: TapRegion(
                    groupId: _rulesTapRegion,
                    child: const _RulesGuideCard(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimationVideo extends StatelessWidget {
  const _AnimationVideo({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final videoSize = controller.value.size;

    if (videoSize.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExcludeSemantics(
      child: IgnorePointer(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoSize.width,
            height: videoSize.height,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}

class _RulesPill extends StatelessWidget {
  const _RulesPill({required this.isGuideVisible, required this.onTap});

  final bool isGuideVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: isGuideVisible,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: TockingColors.rulesPill,
          borderRadius: BorderRadius.circular(TockingRadii.rulesPill),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TockingRadii.rulesPill),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('home-rules-pill-button'),
              onTap: onTap,
              child: Padding(
                key: const Key('home-rules-pill-padding'),
                padding: const EdgeInsets.symmetric(
                  horizontal: TockingSpacing.rulesPillHorizontalPadding,
                  vertical: TockingSpacing.rulesPillVerticalPadding,
                ),
                child: Center(
                  child: Text(
                    '토론 규칙',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: TockingColors.onDark,
                      fontSize: TockingSizes.rulesPillTextSize,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RulesGuideArrow extends StatelessWidget {
  const _RulesGuideArrow();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.7853981633974483,
      child: const SizedBox.square(
        key: Key('home-rules-guide-arrow'),
        dimension: TockingSizes.rulesGuideArrow,
        child: DecoratedBox(
          decoration: BoxDecoration(color: TockingColors.rulesGuideCard),
        ),
      ),
    );
  }
}

class _RulesGuideCard extends StatelessWidget {
  const _RulesGuideCard();

  static const List<_RuleText> _rules = [
    _RuleText('토론방 입장 시 자신의 입장을 선택하고, 토론방에서 사용할 닉네임을 입력해야 합니다.'),
    _RuleText('"발언권 신청"을 통해 발언 순서를 획득 후 발언이 가능합니다.'),
    _RuleText('발언권 순서가 되면 3분 이내 발언을 완료해야 합니다.'),
    _RuleText(
      '발언순서는 찬성/반대의 입장이 번갈아가며 진행됩니다.',
      detail:
          '(단, 기본적으로 번갈아 진행하되, 상대 입장의 발언대기자가 없을 경우 같은 입장의 발언을 연속적으로 할 수 있습니다.)',
    ),
    _RuleText('토론 중간에 찬성/반대의 입장을 변경할 수 있습니다.'),
    _RuleText('토론방은 생성 된 시간으로 부터 2시간동안 유지됩니다.'),
    _RuleText('토론방이 종료되는 시점에 자신의 입장 및 가장 설득력이 있었던 회원을 추천합니다.'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('home-rules-guide-card'),
      decoration: BoxDecoration(
        color: TockingColors.rulesGuideCard,
        borderRadius: BorderRadius.circular(TockingRadii.rulesGuide),
        boxShadow: const [
          BoxShadow(
            color: TockingColors.rulesGuideShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(TockingSpacing.rulesGuidePadding),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TockingSizes.rulesGuideContentWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RulesGuideTitle(),
                const SizedBox(height: TockingSpacing.rulesGuideTitleGap),
                for (final rule in _rules) ...[
                  _RuleBullet(rule: rule),
                  const SizedBox(height: TockingSpacing.rulesGuideBulletGap),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RulesGuideTitle extends StatelessWidget {
  const _RulesGuideTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.campaign,
          color: TockingColors.rulesGuideIcon,
          size: TockingSizes.rulesGuideIcon,
        ),
        const SizedBox(width: 6),
        Text(
          '토론 규칙 안내',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: TockingColors.rulesGuideText,
            fontSize: TockingSizes.rulesGuideTitleTextSize,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _RuleBullet extends StatelessWidget {
  const _RuleBullet({required this.rule});

  final _RuleText rule;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: TockingColors.rulesGuideText,
      fontSize: TockingSizes.rulesGuideBodyTextSize,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
    );
    final detailStyle = textStyle?.copyWith(
      color: TockingColors.rulesGuideSubText,
      fontSize: TockingSizes.rulesGuideDetailTextSize,
      fontWeight: FontWeight.w600,
      height: 1.22,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: TockingSpacing.rulesGuideBulletDotWidth,
          child: Text('•', style: textStyle),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(rule.text, style: textStyle),
              if (rule.detail != null) Text(rule.detail!, style: detailStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleText {
  const _RuleText(this.text, {this.detail});

  final String text;
  final String? detail;
}
