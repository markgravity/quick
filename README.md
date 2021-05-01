# Quick

------

It provides the same feeling with using [Quick](https://github.com/Quick/Quick) in swift

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_test.dart';

void main() {
  describe("the 'Documentation' directory", () {
    it("has everything you need to get started", () {
      final sections = Directory("Documentation").sectionsexpect(
          sections, contains("Organized Tests with Quick Examples and Example Groups"));
      expect(sections, contains("Installing Quick"));
    });

    context("if it doesn't have what you're looking for", () {
      it("needs to be updated", () {
        final you = You(awesome: true);
        expect(you.submittedAnIssue, isTrue);
      });
    });
  });
}
```



## Usage

### Examples Using `it`

Examples, defined with the it function, use assertions to demonstrate how code should behave. These are like test methods in flutter_test.

it takes two parameters: the name of the example, and a function. The examples below specify how the Sea.Dolphin class should behave. A new dolphin should be smart and friendly:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_test.dart';

void main() {
  it("is friendly", () {
    expect(Dolphin().isFriendly, isTrue);
  });

  it("is smart", () {
    expect(Dolphin().isSmart, isTrue);
  });
}
```



### Example Groups Using `describe` and `context`

Example groups are logical groupings of examples. Example groups can share setup and teardown code.

#### Describing Classes and Methods Using `describe`

To specify the behavior of the Dolphin class's click method--in other words, to test the method works--several it examples can be grouped together using the describe function. Grouping similar examples together makes the spec easier to read:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_test.dart';

void main() {
  describe("a dolphin",() {
    describe("its click", () {
      it("is loud", () {
        final click = Dolphin().click();
        expect(click.isLoud, isTrue);
      });

      it("has a high frequency", () {
        final click = Dolphin().click();
        expect(click.hasHighFrequency, isTrue);
      });
    });
  });
}
```



#### Sharing Setup/Teardown Code Using beforeEach and afterEach

Example groups don't just make the examples clearer, they're also useful for sharing setup and teardown code among examples in a group.

In the example below, the `beforeEach` function is used to create a brand new instance of a dolphin and its click before each example in the group. This ensures that both are in a "fresh" state for every example:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_test.dart';

void main() {
  describe("a dolphin", () {
    Dolphin dolphin;
    beforeEach(() {
      dolphin = Dolphin();
    });

    describe("its click", () {
      Click click;
      beforeEach(() {
        click = dolphin.click();
      });

      it("is loud", () {
        expect(click.isLoud, isTrue);
      });

      it("has a high frequency", () {
        expect(click.hasHighFrequency, isTrue);
      });
    });
  });
}
```

Sharing setup like this might not seem like a big deal with the dolphin example, but for more complicated objects, it saves a lot of typing!

To execute code after each example, use `afterEach`.

#### Specifying Conditional Behavior Using context

Dolphins use clicks for echolocation. When they approach something particularly interesting to them, they release a series of clicks in order to get a better idea of what it is.

The tests need to show that the `click` method behaves differently in different circumstances. Normally, the dolphin just clicks once. But when the dolphin is close to something interesting, it clicks several times.

This can be expressed using `context` functions: one `context` for the normal case, and one context for when the dolphin is close to something interesting:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  describe("a dolphin", () {
    Dolphin dolphin;
    beforeEach(() {
      dolphin = Dolphin();
    });

    describe("its click", () {
      context("when the dolphin is not near anything interesting", () {
        it("is only emitted once", () {
          verify(dolphin.click()).called(1);
        });
      });

      context("when the dolphin is near something interesting", () {
        beforeEach(() {
          final ship = SunkenShip();
          Jamaica.dolphinCove.add(ship);
          Jamaica.dolphinCove.add(dolphin);
        });

        it("is emitted three times", () {
          verify(dolphin.click()).called(3);
        });
      });
    });
  });
}
```



### Test vs Widget Test

- Import `quick_test.dart` when writing test and `quick_widget_test.dart` for widget test
- In Wiget Test: `beforeEach`, `afterEach`, `it`are included a widget tester

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quick/quick_widget_test.dart';

void main() {
  describe("a message widget", () {
    beforeEach((tester) async {
      await tester.pumpWidget(MessageWidget("a message"));
    });

    it("shows a message", (tester) async {
      expect(find.text("a message"), findsOneWidget);
    });
  });
}
```