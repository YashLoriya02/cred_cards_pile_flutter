import 'bill_card.dart';

class CardsAnimationConfig {
  final int count;
  final int delaySeconds;
  final double durationSeconds;

  const CardsAnimationConfig({
    required this.count,
    required this.delaySeconds,
    required this.durationSeconds,
  });

  factory CardsAnimationConfig.fromJson(Map<String, dynamic> json) {
    return CardsAnimationConfig(
      count: (json['count'] ?? 0) as int,
      delaySeconds: (json['delay'] ?? 0) as int,
      durationSeconds:
          double.tryParse(json['duration']?.toString() ?? '0') ?? 0,
    );
  }
}

class BillSection {
  final String title;
  final bool autoScrollEnabled;
  final int? billsCount;
  final CardsAnimationConfig? anim;
  final List<BillCardModel> cards;

  const BillSection({
    required this.title,
    required this.autoScrollEnabled,
    required this.billsCount,
    required this.anim,
    required this.cards,
  });

  factory BillSection.fromJson(Map<String, dynamic> json) {
    final props = (json['template_properties'] ?? {}) as Map<String, dynamic>;
    final body = (props['body'] ?? {}) as Map<String, dynamic>;

    print(
      "Cards length in model: ${((props['child_list'] ?? []) as List).length}",
    );

    final childs = (props['child_list'] ?? []) as List;

    return BillSection(
      title: body['title']?.toString() ?? 'UPCOMING BILLS',
      autoScrollEnabled: (body['auto_scroll_enabled'] ?? false) as bool,
      billsCount: int.tryParse(body['bills_count']?.toString() ?? ''),
      anim: body['cards_animation_config'] != null
          ? CardsAnimationConfig.fromJson(
              (body['cards_animation_config'] as Map).cast<String, dynamic>(),
            )
          : null,
      cards: BillCardModel.listFromJson(childs),
    );
  }
}
