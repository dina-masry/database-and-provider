class ProcessResponse{
  late String message;
  late bool success;

  ProcessResponse({
    required this.message,
    this.success = false,
  });
}