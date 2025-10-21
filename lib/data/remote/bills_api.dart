import 'dart:convert';
import 'package:http/http.dart' as http;

class BillsApi {
  final http.Client Function() client;
  BillsApi({required this.client});

  static http.Client defaultClient() => http.Client();

  Uri _jsonBlobUri(String id) =>
      Uri.parse('https://jsonblob.com/api/jsonBlob/$id');

  Future<Map<String, dynamic>> fetchMockSection({String? urlOverride}) async {
    final url = urlOverride != null
        ? Uri.parse(urlOverride)
        : _jsonBlobUri("1425066643679272960"); // For > 2 Cards
    // : _jsonBlobUri("1425067032428339200"); // For <= 2 Cards

    try {
      final res = await client().get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode == 200) {
        final ct = res.headers['content-type'] ?? '';
        if (!ct.toLowerCase().contains('application/json')) {
          throw FormatException('Expected JSON, got: $ct');
        }

        final data = json.decode(res.body) as Map<String, dynamic>;
        final cardsLen =
            (data['template_properties']?['child_list'] as List?)?.length ?? 0;
        print('Cards in API: $cardsLen');
        return data;
      } else {
        print('HTTP ${res.statusCode}: ${res.reasonPhrase}');
      }
    } catch (e) {
      print('Network/parse error: $e');
    }

    // Fallback
    return _embeddedMock;
  }
}

const Map<String, dynamic> _embeddedMock = {
  "entity_type": "section",
  "external_id":
      "section_ab18b286-ff33-4072-992d-f3727c6809ff:ab18b286-ff33-4072-992d-f3727c6809ff",
  "template_name": "your_bills_section_horizontal",
  "template_properties": {
    "body": {
      "auto_scroll_enabled": true,
      "badge": {
        "cta": {"type": "deeplink"},
        "icon":
            "https://assets.dreamplug.in/octapaul/heartbeat/de0d37b0a85811edb942dd1d2dcae4c2.png",
      },
      "bills_count": "2",
      "cards_animation_config": {"count": 10, "delay": 3, "duration": "0.7"},
      "orientation": "vertical",
      "template_type": "your_bills_section_horizontal",
      "title": "UPCOMING BILLS",
    },
    "child_list": [
      {
        "entity_type": "card",
        "external_id":
            "card_1839f4a6-0e4c-4dc3-9fcf-f85234cba40a:mobile_postpaid_8ff9f248-4001-44ce-8529-147dd589dc5f",
        "template_name": "your_bills_card_vertical",
        "template_properties": {
          "background": {
            "asset": {
              "type": "image",
              "url":
                  "https://d1sofudel0ufia.cloudfront.net/fabrik/nba/0424f010a50211ecab1fc5eccc1abf56.png",
            },
            "color": {
              "colors": ["#FFFFFF"],
              "direction": " TopLeft_BottomRight",
            },
          },
          "body": {
            "footer_text": "due today",
            "logo": {
              "bg_color": "#ffffff",
              "shape": "rectangle",
              "url":
                  "https://d23irbddtnqndj.cloudfront.net/assets/biller/VODA00000NAT96.gif",
            },
            "payment_amount": "₹200",
            "sub_title": "Miss Blake Murazik",
            "template_type": "your_bills_card_vertical",
            "title": "VIL",
          },
          "ctas": {
            "primary": {
              "background_color": "#FFFFFF",
              "title": "Pay ₹200",
              "type": "deeplink",
            },
          },
        },
      },
      {
        "entity_type": "card",
        "external_id":
            "card_1839f4a6-0e4c-4dc3-9fcf-f85234cba40a:4cec06ba-7d8b-487c-a228-00da05dc2d4d",
        "template_name": "your_bills_card_vertical",
        "template_properties": {
          "background": {
            "color": {
              "colors": ["#FFFFFF"],
              "direction": " TopLeft_BottomRight",
            },
          },
          "body": {
            "flipper_config": {
              "final_stage": {"text": "DUE TODAY"},
              "flip_count": 1,
              "flip_delay": 2000,
              "items": [
                {"text": "GET 1% BACK AS GOLD UPTO ₹200"},
                {"text": "DUE TODAY"},
              ],
            },
            "logo": {
              "bg_color": "#ffffff",
              "shape": "rectangle",
              "url":
                  "https://dg1qgqhnfu4m2.cloudfront.net/heartbeat/aa501250a12c11ec9ffdcf8085fda1bd.png",
            },
            "payment_amount": "₹45,000",
            "payment_tag": "OUTSTANDING",
            "sub_title": "XXXX XXXX 6582",
            "template_type": "your_bills_card_vertical",
            "title": "HDFC Bank",
          },
          "ctas": {
            "primary": {
              "background_color": "#ffffff",
              "title": "Pay ₹45,000",
              "type": "deeplink",
            },
          },
        },
      },
    ],
    "ctas": {
      "primary": {"title": "view all", "type": "deeplink"},
    },
  },
};
