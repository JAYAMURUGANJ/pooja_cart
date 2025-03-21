class ApiResponse<T> {
  final String status;
  final dynamic result;
  final String? statusCode;
  final String? errorMessage;

  ApiResponse({
    required this.status,
    required this.result,
    this.statusCode,
    this.errorMessage,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      result: json['result'],
      statusCode: json['status_code'],
      errorMessage: json['error_message'],
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';

  String get error {
    if (status == 'error') {
      return errorMessage ?? result.toString();
    }
    return '';
  }
}
