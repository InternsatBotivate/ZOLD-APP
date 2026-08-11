import 'package:flutter_test/flutter_test.dart';
import 'package:zold_gold/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZoldApp());
    expect(find.text('ZOLD - Gold for GenZ'), findsOneWidget);
  });
}
