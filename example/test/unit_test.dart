import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_test/quick_test.dart';

enum BrandType { unknown, audi, bmw, f1 }

abstract class Driveable {
  void drive();

  void stop();
}

class Vehicle implements Driveable {
  int numberOfWheels = 1;

  BrandType brand = BrandType.unknown;

  void drive() {
    print("I am driving");
  }

  void stop() {
    print("I am stopped");
  }
}

class Car extends Vehicle {
  @override
  int numberOfWheels = 4;
}

/// TEST
void main() {
  describe("a vehicle", () {
    // Context without a vehicle type
    context("after being properly initialized", () {
      final vehicle = Vehicle();

      it("should have a brand", () {
        expect(vehicle.brand, isNotNull);
      });
    });

    // Context using vehicle type
    context("after being properly initialized using vehicle type", () {
      final expectedCarWheels = 4;
      final vehicle = Car();

      it("should have a brand", () {
        expect(vehicle.brand, isNotNull);
      });

      it("should have number of wheels constrained to its type", () {
        expect(vehicle.numberOfWheels, expectedCarWheels);
      });
    });
  });
}
