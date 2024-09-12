Piece of the flutter_reference repository meant to demonstrate the use of a library.

This library exposes a `StepUpPrompt` widget to be shown in a modal page, with callbacks for when the operation succeeds and fails. It can be used as a regular widget, but importantly the SDK must first be initialized by calling the `initialize` function, otherwise exceptions will be thrown when using the widget.

The intended usage is to show the Step Up Prompt in a blocking modal page when a request is refused with a _step-up required_ response. Then, a step-up authentication code can be obtained using the prompt and included as a header in a request retry.

In this demo, a successful prompt always produces the string "諸行無常 諸行是苦 諸法無我" as a step-up authorization token.
