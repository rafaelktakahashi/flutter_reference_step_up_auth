import 'package:flutter/material.dart';
import 'package:flutter_reference_step_up_auth/src/domain/error.dart';
import 'package:flutter_reference_step_up_auth/src/service/auth_service.dart';
import 'package:flutter_reference_step_up_auth/src/ui/prompt.dart';

// These functions are just for having constant default values for the
// callback parameters.
void _constFailureToVoid(StepUpPromptFailureReason _) {}
void _constStrToVoid(String _) {}

/// Step up prompt that asks for a code sent to the user (this demo doesn't
/// actually send anything to the user and always considers "42" as the only
/// correct code). When the wrong code is provided by the user, this does not
/// fail immediately, and only warns the user that the code is wrong. The user
/// may press a button to cause a failure manually, and in a real SDK the user
/// should be able to cancel the operation, not necessarily through this widget.
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
  final void Function(StepUpPromptFailureReason) onFailure;

  const StepUpPrompt({
    super.key,
    required this.sessionId,
    this.onSuccess = _constStrToVoid,
    this.onFailure = _constFailureToVoid,
  });

  @override
  State<StatefulWidget> createState() {
    return _StepUpPromptState();
  }
}

class _StepUpPromptState extends State<StepUpPrompt> {
  String inputCode = "";
  bool verifying = false;

  @override
  Widget build(BuildContext context) {
    return Prompt(
      largeText: "Step-up Authentication",
      smallText:
          "This prompt is being shown because the request you attempted requires additional verification."
          "\n"
          "Please write \"42\" and press the big blue button to confirm your identity (or the big red button to fail the request.)"
          "\n\n"
          "(In a real app, you'd receive an alphanumeric code to input here.)",
      backgroundColor: Colors.blue[300],
      extra: OverflowBar(children: [
        TextField(
          key: const Key("step-up-auth-code-input"),
          decoration: const InputDecoration(hintText: "Verification code"),
          onChanged: (value) {
            setState(() {
              inputCode = value;
            });
          },
        ),
        ElevatedButton(
          key: const Key("step-up-auth-confirm-button"),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.blue[700]),
          ),
          onPressed: verifying
              ? null
              : () {
                  setState(() {
                    verifying = true;
                  });
                  verifyCode(inputCode, widget.sessionId).then((value) {
                    widget.onSuccess(value);
                  }).catchError((error) {
                    // An exception may be thrown here in case of a network
                    // or token error with the verifyCode function.
                    if (error case StepUpAuthError(errorCode: "001")) {
                      widget.onFailure(
                          StepUpPromptFailureReason.libraryUninitialized);
                    } else if (error case StepUpAuthError(errorCode: "002")) {
                      // Don't call the failure callback; this error code means
                      // the verification code was incorrect, and the modal
                      // page should remain on-screen.
                      if (context.mounted) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Incorrect code'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('The verification code is incorrect.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Continue'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((_) {
                          setState(() {
                            verifying = false;
                          });
                        });
                      }
                    } else if (error case StepUpAuthError(errorCode: "003")) {
                      widget.onFailure(StepUpPromptFailureReason.networkError);
                    } else if (error case StepUpAuthError(errorCode: "004")) {
                      widget.onFailure(StepUpPromptFailureReason
                          .authServerConfigurationError);
                    }
                  });
                },
          child: Text(
            key: const Key("step-up-auth-confirm-button-text"),
            verifying ? "VERIFYING..." : "CONFIRM",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          key: const Key("step-up-auth-fail-button"),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.red[700]),
          ),
          onPressed: () {
            widget.onFailure(StepUpPromptFailureReason.userDismissed);
          },
          child: const Text(
            key: Key("step-up-auth-fail-button-text"),
            "FAIL AND LEAVE",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}

enum StepUpPromptFailureReason {
  networkError,
  authServerConfigurationError,
  libraryUninitialized,
  userDismissed,
}
