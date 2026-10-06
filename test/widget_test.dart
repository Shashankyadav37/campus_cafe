import 'package:campus_cafe/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CampusCafe app loads', (tester) async {
    await tester.pumpWidget(const CampusCafeApp());

    expect(find.text('CampusCafe'), findsOneWidget);
    expect(find.text('Hello, Student! 👋'), findsOneWidget);
  });
}
