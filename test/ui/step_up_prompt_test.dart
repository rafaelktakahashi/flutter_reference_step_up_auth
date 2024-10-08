import 'package:flutter/material.dart';
import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_wrapper.dart';

void main() {
  group("Correctly initialized widget", () {
    setUp(() async {
      initialize(clientToken: "clientToken");
    });
    testWidgets("Step-up prompt has text", (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: StepUpPrompt(sessionId: "sessionId"),
        ),
      );

      expect(find.text("Step-up Authentication"), findsAny);
    });

    testWidgets("Step-up prompt can be written to", (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: StepUpPrompt(sessionId: "sessionId"),
        ),
      );
      await tester.enterText(
        find.byKey(const Key("step-up-auth-code-input")),
        "42",
      );

      expect(find.text("42"), findsOne);
    });

    testWidgets("Step-up prompt can be confirmed", (tester) async {
      int callCounter = 0;
      await tester.pumpWidget(
        TestWrapper(
          child: StepUpPrompt(
            sessionId: "sessionId",
            onSuccess: (_) {
              callCounter++;
            },
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const Key("step-up-auth-code-input")),
        "42",
      );
      await tester.tap(
        find.byKey(const Key("step-up-auth-confirm-button")),
      );

      expect(callCounter, 1);
    });

    testWidgets("Step-up prompt can't be confirmed when empty", (tester) async {
      int callCounter = 0;
      await tester.pumpWidget(
        TestWrapper(
          child: StepUpPrompt(
            sessionId: "sessionId",
            onSuccess: (_) {
              callCounter++;
            },
          ),
        ),
      );
      await tester.tap(
        find.byKey(const Key("step-up-auth-confirm-button")),
      );

      expect(callCounter, 0);
    });

    testWidgets("Step-up prompt can be canceled", (tester) async {
      int callCounter = 0;
      await tester.pumpWidget(
        TestWrapper(
          child: StepUpPrompt(
            sessionId: "sessionId",
            onFailure: (_) {
              callCounter++;
            },
          ),
        ),
      );
      await tester.tap(
        find.byKey(const Key("step-up-auth-fail-button")),
      );

      expect(callCounter, 1);
    });
  });
}
