// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../data/models/bill_card.dart';
import '../../../utils/bill_util.dart'; // formatMoney()

class BillsTwoCardList extends StatelessWidget {
  final String title;
  final List<BillCardModel> cards;
  final int globalFlipIndex;

  const BillsTwoCardList({
    super.key,
    required this.title,
    required this.cards,
    required this.globalFlipIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            children: [
              Text(
                '${title.toUpperCase()} (${cards.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
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
          const SizedBox(height: 50),
          for (int i = 0; i < cards.length; i++) ...[
            _BillRowTile(
              card: cards[i],
              rotatingMessages: _messagesFor(cards[i]),
              globalFlipIndex: globalFlipIndex,
            ),
            if (i < cards.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  static List<String> _messagesFor(BillCardModel c) {
    final flipper = c.flipper?.items.map((e) => e.text).toList() ?? [];
    if (flipper.length >= 2) {
      return flipper.map((s) => s.toUpperCase()).toList();
    }

    final a = (c.footerText ?? c.paymentTag ?? 'AUTOPAY IN 9 DAYS')
        .toUpperCase();
    final b = (c.flipper?.finalStageText ?? 'AUTOPAY IN 9 DAYS').toUpperCase();
    return a == b ? [a, 'AUTOPAY IN 9 DAYS'] : [a, b];
  }
}

class _BillRowTile extends StatelessWidget {
  final BillCardModel card;
  final List<String> rotatingMessages;
  final int globalFlipIndex;

  const _BillRowTile({
    required this.card,
    required this.rotatingMessages,
    required this.globalFlipIndex,
  });

  @override
  Widget build(BuildContext context) {
    final idx = rotatingMessages.isEmpty
        ? 0
        : (globalFlipIndex % rotatingMessages.length);
    final subtitle = rotatingMessages.isEmpty ? '' : rotatingMessages[idx];

    const double rightColWidth = 150;

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.black.withOpacity(0.10)),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LogoCircle(url: card.logoUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _ProviderAndMasked(subTitle: card.subTitle),
                ],
              ),
            ),
          ),

          SizedBox(
            width: rightColWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AmountPill(amountText: formatMoney(card.amount)),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Text(
                    subtitle,
                    key: ValueKey('green-$idx-${card.externalId}'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF18A47B),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  final String? url;
  const _LogoCircle({this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: SizedBox(
          width: 36,
          height: 36,
          child: url == null
              ? const SizedBox.shrink()
              : Image.network(
                  url!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
        ),
      ),
    );
  }
}

class _ProviderAndMasked extends StatelessWidget {
  final String subTitle; // e.g. "XXXX XXXX 9006"
  const _ProviderAndMasked({required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final looksMasked = subTitle.toUpperCase().contains('XXXX');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (looksMasked) _VisaSmallBadge(),
        if (looksMasked) const SizedBox(width: 6),
        Flexible(
          child: Text(
            subTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withOpacity(0.55),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _VisaSmallBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2962FF).withOpacity(0.35)),
      ),
      child: const Text(
        'VISA',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xFF2962FF),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _AmountPill extends StatelessWidget {
  final String amountText;
  const _AmountPill({required this.amountText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withOpacity(0.65), width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // autopay glyph placeholder
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF18A47B), width: 1.5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'A',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF18A47B),
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amountText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
