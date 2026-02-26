class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  // Success case
  factory ApiResponse.success(T data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  // Error case
  factory ApiResponse.error(String message) {
    return ApiResponse._(
      error: message,
      isSuccess: false,
    );
  }
}