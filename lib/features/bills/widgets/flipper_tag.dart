// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../data/models/bill_card.dart';

class FlipperTag extends StatelessWidget {
  final BillCardModel card;
  final int globalFlipIndex;
  const FlipperTag({
    super.key,
    required this.card,
    required this.globalFlipIndex,
  });

  @override
  Widget build(BuildContext context) {
    final flipper = card.flipper;
    final items = flipper?.items ?? const [];
    if (flipper == null || items.isEmpty) {
      final text = card.footerText ?? card.paymentTag ?? '';
      if (text.isEmpty) return const SizedBox.shrink();
      return _Tag(text: text);
    }

    final idx = items.isEmpty ? 0 : (globalFlipIndex % items.length);
    final text = items[idx].text;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: _Tag(key: ValueKey('tag-$idx-${card.externalId}'), text: text),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.88),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
