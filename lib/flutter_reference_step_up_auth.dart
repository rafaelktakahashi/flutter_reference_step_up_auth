library flutter_reference_step_up_auth;

import 'package:flutter_reference_step_up_auth/src/service/auth_service.dart';
export 'package:flutter_reference_step_up_auth/src/ui/step_up_prompt.dart'
    show StepUpPrompt;

/// Initialize the Step Up Auth SDK.
///
/// This function must be called before any other functionality of this SDK
/// can be used. Using the Widgets from this SDK without prior initialization
/// will cause exceptions to be thrown when
void initialize({
  required String clientToken,
}) {
  initializeAuthService(clientToken: clientToken);
}
