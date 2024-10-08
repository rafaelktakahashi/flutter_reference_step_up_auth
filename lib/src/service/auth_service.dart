import 'package:flutter_reference_step_up_auth/src/domain/error.dart';

AuthServiceState _authServiceState = const AuthServiceStateUninitialized();

abstract class AuthServiceState {
  const AuthServiceState();
}

class AuthServiceStateUninitialized extends AuthServiceState {
  const AuthServiceStateUninitialized();
}

class AuthServiceStateInitialized extends AuthServiceState {
  final String clientToken;
  const AuthServiceStateInitialized({
    required this.clientToken,
  });
}

// Must be called before any other operations are allowed.
void initializeAuthService({
  required String clientToken,
}) {
  _authServiceState = AuthServiceStateInitialized(clientToken: clientToken);
}

/// Verifies if the code input by the user is correct.
/// If it's correct, the authentication code is returned; otherwise, an error
/// is thrown.
///
/// Error codes:
/// - 001 - SDK is not initialized.
/// - 002 - Incorrect code.
/// - 003 - Network error.
/// - 004 - Credencials configured for the SDK are invalid.
Future<String> verifyCode(String code, String sessionId) async {
  if (_authServiceState is AuthServiceStateUninitialized) {
    throw const StepUpAuthError(
      errorCode: "001",
      devMessage: "SDK is not yet initialized.",
    );
  }

  if (code == "42") {
    // Fixed string that we return as a successfuly obtained code.
    return "諸行無常 諸行是苦 諸法無我";
  }

  throw const StepUpAuthError(
    errorCode: "002",
    devMessage: "The code provided is incorrect.",
  );
}
