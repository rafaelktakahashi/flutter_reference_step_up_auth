import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart';
import 'package:flutter_reference_step_up_auth/src/domain/error.dart';
import 'package:flutter_reference_step_up_auth/src/service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Missing initialization', () {
    test("Verify code", () {
      expectLater(() async {
        return verifyCode("42", "abc");
      },
          throwsA(isA<StepUpAuthError>()
              .having((e) => e.errorCode, "errorCode", equals("001"))));
    });
    test("Verify calls do not complete.", () async {
      try {
        final _ = await verifyCode("42", "abc");
        fail("verifyCode should not have returned a value.");
      } catch (e) {
        expect(e, isA<StepUpAuthError>());
      }
    });
  });
  group('Correct initialization', () {
    setUp(() {
      initialize(clientToken: "clientToken");
    });
    test("Verify correct code", () async {
      final resultingToken = await verifyCode("42", "sessionId");
      // This is a fixed string that this demo project always returns
      // when the verification code is "42".
      // Of course, in a real library we would mock whatever dependency the
      // service uses, then verify that the mocked value is returned here.
      expect(resultingToken, equals("諸行無常 諸行是苦 諸法無我"));
    });
    test("Verify incorrect code", () async {
      final resultingToken = await verifyCode("43", "sessionId");
      expect(resultingToken, equals(null));
    });
  });
}
