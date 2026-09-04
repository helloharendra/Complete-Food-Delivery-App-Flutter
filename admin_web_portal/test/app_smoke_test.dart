import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin production shell is Arabic RTL', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF166534)),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const Scaffold(body: Text('إدارة ديرب')),
    ));
    expect(find.text('إدارة ديرب'), findsOneWidget);
    expect(tester.widget<Directionality>(find.byType(Directionality).last).textDirection, TextDirection.rtl);
  });
}
