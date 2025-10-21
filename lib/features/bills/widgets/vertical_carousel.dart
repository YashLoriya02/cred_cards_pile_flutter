// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/bill_section.dart';
import 'bill_card.dart';

class VerticalBillsCarousel extends StatefulWidget {
  final BillSection section;
  final int globalFlipIndex;

  const VerticalBillsCarousel({
    super.key,
    required this.section,
    required this.globalFlipIndex,
  });

  @override
  State<VerticalBillsCarousel> createState() => _VerticalBillsCarouselState();
}

class _VerticalBillsCarouselState extends State<VerticalBillsCarousel> {
  static const double kCardHeight = 156;

  static const double kGhost1Inset = 26;
  static const double kGhost2Inset = 44;

  static const double kGhostHeight = 16;
  static const double kGhostSpacing = 10;

  // Subtle depth
  static const double _minScale = 0.96;
  static const double _liftPx = 6;
  static const double _dim = 0.08;

  late final double _deckHeight; // exactly 2 cards + gap
  late final double _viewportFraction; // page height / deck height
  PageController? _controller;
  Timer? _autoTimer;
  int _current = 0;

  double get _animDurationMs =>
      ((widget.section.anim?.durationSeconds ?? 0.7) * 1000).clamp(200, 1000);

  int get _autoDelaySec => (widget.section.anim?.delaySeconds ?? 3).clamp(1, 8);

  bool get _twoOrLess => widget.section.cards.length <= 2;

  @override
  void initState() {
    super.initState();
    _deckHeight = (kCardHeight * 2);
    _viewportFraction = (kCardHeight / _deckHeight).clamp(0.35, 0.98);

    _controller = PageController(viewportFraction: _viewportFraction);

    if (!_twoOrLess && widget.section.autoScrollEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAuto());
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _startAuto() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(Duration(seconds: _autoDelaySec), (_) {
      if (!mounted || _controller == null || !_controller!.hasClients) return;
      final last = widget.section.cards.length - 1;
      _current = _controller!.page?.round() ?? _current;
      final next = _current >= last ? 0 : _current + 1;
      _controller!.animateToPage(
        next,
        duration: Duration(milliseconds: _animDurationMs.toInt()),
        curve: Curves.easeOutCubic,
      );
      _current = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.section.cards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              Text(
                '${widget.section.title.toUpperCase()} (${cards.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Row(
                children: const [
                  Text(
                    'view all',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            height: _deckHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 0,
                  left: kGhost2Inset,
                  right: kGhost2Inset,
                  child: _ghostBar(
                    height: kGhostHeight,
                    blur: 10,
                    yOffset: 6,
                    opacity: 0.04,
                  ),
                ),
                SizedBox(height: 1),
                Positioned(
                  bottom: kGhostSpacing,
                  left: kGhost1Inset,
                  right: kGhost1Inset,
                  child: _ghostBar(
                    height: kGhostHeight,
                    blur: 12,
                    yOffset: 8,
                    opacity: 0.06,
                  ),
                ),

                AnimatedBuilder(
                  animation: _controller!,
                  builder: (context, _) {
                    final page = _controller!.positions.isNotEmpty
                        ? (_controller!.page ??
                              _controller!.initialPage.toDouble())
                        : 0.0;

                    return PageView.builder(
                      controller: _controller!,
                      scrollDirection: Axis.vertical,
                      padEnds: false,
                      pageSnapping: true,
                      itemCount: cards.length,
                      onPageChanged: (i) => _current = i,
                      itemBuilder: (context, i) {
                        final card = cards[i];
                        final delta = (i - page);
                        final ad = delta.abs();

                        final scale = (1 - (1 - _minScale) * ad).clamp(
                          _minScale,
                          1.0,
                        );
                        final lift = (-_liftPx * ad).clamp(-_liftPx, 0.0);
                        final opacity = (1 - _dim * ad).clamp(0.88, 1.0);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: kCardHeight,
                              child: Transform.translate(
                                offset: Offset(0, lift),
                                child: Transform.scale(
                                  scale: scale,
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: BillCardWidget(
                                      card: card,
                                      globalFlipIndex: widget.globalFlipIndex,
                                      animDurationMs: _animDurationMs.toInt(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _ghostBar({
    required double height,
    required double blur,
    required double yOffset,
    required double opacity,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(opacity),
            blurRadius: blur,
            offset: Offset(0, yOffset),
          ),
        ],
      ),
    );
  }
}
