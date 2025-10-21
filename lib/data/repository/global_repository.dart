import 'package:cred_bills_carousel/data/models/bill_section.dart';
import '../remote/bills_api.dart';

class GlobalRepository {
  final BillsApi _api;
  GlobalRepository(this._api);

  Future<BillSection> fetchBillsSection({String? urlOverride}) async {
    final json = await _api.fetchMockSection(urlOverride: urlOverride);
    return BillSection.fromJson(json);
  }
}
