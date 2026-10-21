import 'package:flutter_test/flutter_test.dart';
import 'package:student_shop/main.dart';

void main() {
  testWidgets('ApplianceHub opens successfully', (tester) async {
    await tester.pumpWidget(const AppliancesApp());
    expect(find.text('ApplianceHub'), findsOneWidget);
  });
}
