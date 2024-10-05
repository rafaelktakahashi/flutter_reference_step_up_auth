import 'package:flutter/material.dart';
import 'package:flutter_reference_step_up_auth/src/ui/prompt.dart';

// These functions are just for having constant default values for the
// callback parameters.
void _constVoid() {}
void _constStrToVoid(String _) {}

class StepUpPrompt extends StatefulWidget {
  /// Value that was returned from the backend server in the error that informed
  /// that step up authentication is required. This value identifies the
  /// authentication session, and is required because alphanumeric codes
  /// generated for one session are not valid for others.
  final String sessionId;

  /// Callback invoked when the user inserts the correct alphanumeric code.
  /// The step up authentication token is passed as a parameter, and and it
  /// should be included in the next request's header.
  final void Function(String) onSuccess;

  /// Callback invoked when the user dismisses the verification; use this to
  /// navigate back and resume the original request with an error.
  /// In this demo, there's a big obvious button that the user can press to
  /// cancel the step-up verification, but in a real app this would happen when
  /// the user fails the verification too many times, leaving the widget in a
  /// permanently failed state with a "back" button.
  final void Function() onFailure;

  const StepUpPrompt({
    super.key,
    required this.sessionId,
    this.onSuccess = _constStrToVoid,
    this.onFailure = _constVoid,
  });

  @override
  State<StatefulWidget> createState() {
    return _StepUpPromptState();
  }
}

class _StepUpPromptState extends State<StepUpPrompt> {
  String? inputCode;

  @override
  Widget build(BuildContext context) {
    return Prompt(
      largeText: "Step-up Authentication",
      smallText:
          "This prompt is being shown because the request you attempted requires additional verification."
          "\n"
          "Please press the big blue button to confirm your identity (or the big red button to fail the request.)"
          "\n\n"
          "(In a real app, you'd receive an alphanumeric code to input here.)",
      backgroundColor: Colors.blue[300],
      extra: OverflowBar(children: [
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.blue[700]),
          ),
          onPressed: () {
            // Invoke the callback with this fixed string. In this demo, this
            // string is always a valid step-up authentication token.
            widget.onSuccess("諸行無常 諸行是苦 諸法無我");
          },
          child: const Text(
            key: Key("step-up-auth-confirm-button"),
            "CONFIRM",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.red[700]),
          ),
          onPressed: () {
            widget.onFailure();
          },
          child: const Text(
            key: Key("step-up-auth-fail-button"),
            "FAIL AND LEAVE",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
