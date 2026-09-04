import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/design/dierb_theme.dart';

void main() {
  testWidgets('customer production shell is Arabic RTL', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: DierbTheme.light(),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const Scaffold(body: Text('ديرب')),
    ));
    expect(find.text('ديرب'), findsOneWidget);
    expect(tester.widget<Directionality>(find.byType(Directionality).last).textDirection, TextDirection.rtl);
  });
}
