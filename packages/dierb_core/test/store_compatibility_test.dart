import 'package:dierb_core/dierb_core.dart';
import 'package:test/test.dart';

void main() {
  test('store accepts legacy text opening hours without crashing', () {
    final store = Store.fromMap('store-1', <String, dynamic>{
      'ownerId': 'merchant-1',
      'name': 'متجر ديرب',
      'categoryId': 'grocery',
      'cityId': 'dierb-nigm',
      'openingHours': '9 ص - 11 م',
      'status': 'approved',
    });

    expect(store.displayHours, '9 ص - 11 م');
    expect(store.openingHours, isEmpty);
    expect(store.publiclyDiscoverable, isTrue);
  });

  test('store continues to parse structured opening hours', () {
    final store = Store.fromMap('store-2', <String, dynamic>{
      'ownerId': 'merchant-2',
      'name': 'صيدلية ديرب',
      'categoryId': 'pharmacy',
      'cityId': 'dierb-nigm',
      'openingHours': <Map<String, dynamic>>[
        <String, dynamic>{'day': 1, 'open': '08:00', 'close': '23:00'},
      ],
      'status': 'approved',
    });

    expect(store.displayHours, '08:00 - 23:00');
  });
}
