// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../data/models/bill_card.dart';
import '../../../utils/bill_util.dart';
import 'flipper_tag.dart';

class BillCardWidget extends StatelessWidget {
  final BillCardModel card;
  final int globalFlipIndex;
  final int animDurationMs;

  const BillCardWidget({
    super.key,
    required this.card,
    required this.globalFlipIndex,
    required this.animDurationMs,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = ensureTwoColors(
      card.bgColorsHex,
      fallback: Colors.white,
    );
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
    );

    final border = BorderRadius.circular(10);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1),
      duration: Duration(milliseconds: animDurationMs),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Transform.scale(scale: value, child: child),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: border,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
          image: card.backgroundUrl != null
              ? DecorationImage(
                  image: NetworkImage(card.backgroundUrl!),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                )
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Foreground content
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.95),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: _Body(card: card, globalFlipIndex: globalFlipIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final BillCardModel card;
  final int globalFlipIndex;
  const _Body({required this.card, required this.globalFlipIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: logo + flipper tag
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Logo(url: card.logoUrl),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                card.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            FlipperTag(card: card, globalFlipIndex: globalFlipIndex),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          card.subTitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        // Amount + CTA
        Row(
          children: [
            Text(
              formatMoney(card.amount),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            if (card.ctaTitle != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor(card.ctaBg ?? '#000000'),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  card.ctaTitle!,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  final String? url;
  const _Logo({this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        color: Colors.white,
        child: url == null
            ? const SizedBox.shrink()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
      ),
    );
  }
}
