class Failure {
  Failure({this.message = "Sorry, an unexpected error occurred"});
  final String message;

  @override
  String toString() => 'Failure(message: $message)';
}
