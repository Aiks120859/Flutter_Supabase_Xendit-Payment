import 'package:flutter_test/flutter_test.dart';
import 'package:student_shop/main.dart';

void main() {
  testWidgets('Student Shop app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentShop());
    await tester.pump();

    expect(find.text('STUDENT SHOP'), findsOneWidget);
  });
}
