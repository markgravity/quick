import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_test/quick_widget_test.dart';

class AWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text("it is me"),
    );
  }
}

void main() {
  describe("a Widget", () {
    beforeEach((tester) async {
      await tester.pumpWidget(AWidget());
    });

    it("contains 'it is me' text", (tester) async {
      expect(find.text("it is me"), findsOneWidget);
    });
  });
}
