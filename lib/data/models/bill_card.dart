class FlipperItem {
  final String text;
  FlipperItem(this.text);
}

class FlipperConfig {
  final List<FlipperItem> items;
  final int flipCount; // Optional
  final int flipDelayMs;
  final String? finalStageText;

  const FlipperConfig({
    required this.items,
    required this.flipCount,
    required this.flipDelayMs,
    this.finalStageText,
  });

  factory FlipperConfig.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? [])
        .map((e) => FlipperItem((e as Map)['text'] as String))
        .toList();
    return FlipperConfig(
      items: items,
      flipCount: (json['flip_count'] ?? 0) as int,
      flipDelayMs: (json['flip_delay'] ?? 0) as int,
      finalStageText: (json['final_stage']?['text']) as String?,
    );
  }
}

class BillCardModel {
  final String externalId;
  final String title;
  final String subTitle;
  final String amount; // e.g., ₹45,000
  final String? paymentTag; // e.g., OUTSTANDING
  final String? footerText; // e.g., due today
  final String? logoUrl;
  final String? backgroundUrl;
  final List<String>? bgColorsHex;
  final String? ctaTitle;
  final String? ctaBg;
  final FlipperConfig? flipper;

  BillCardModel({
    required this.externalId,
    required this.title,
    required this.subTitle,
    required this.amount,
    this.paymentTag,
    this.footerText,
    this.logoUrl,
    this.backgroundUrl,
    this.bgColorsHex,
    this.ctaTitle,
    this.ctaBg,
    this.flipper,
  });

  factory BillCardModel.fromJson(Map<String, dynamic> json) {
    final props = (json['template_properties'] ?? {}) as Map<String, dynamic>;
    final body = (props['body'] ?? {}) as Map<String, dynamic>;
    final bg = (props['background'] ?? {}) as Map<String, dynamic>;
    final colors = (bg['color']?['colors'] as List?)
        ?.map((e) => e.toString())
        .toList();

    return BillCardModel(
      externalId: json['external_id']?.toString() ?? '',
      title: body['title']?.toString() ?? '',
      subTitle: body['sub_title']?.toString() ?? '',
      amount: body['payment_amount']?.toString() ?? '',
      paymentTag: body['payment_tag']?.toString(),
      footerText: body['footer_text']?.toString(),
      logoUrl: body['logo']?['url']?.toString(),
      backgroundUrl: bg['asset']?['url']?.toString(),
      bgColorsHex: colors,
      ctaTitle: props['ctas']?['primary']?['title']?.toString(),
      ctaBg: props['ctas']?['primary']?['background_color']?.toString(),
      flipper: body['flipper_config'] != null
          ? FlipperConfig.fromJson(
              (body['flipper_config'] as Map).cast<String, dynamic>(),
            )
          : null,
    );
  }

  static List<BillCardModel> listFromJson(List input) => input
      .map((e) => BillCardModel.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}
