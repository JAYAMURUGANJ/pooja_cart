class ApiResponse {
  final int? statusCode;
  final bool? status;
  final List<dynamic>? data;
  final String? message;

  ApiResponse({this.statusCode, this.status, this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    statusCode: json["status_code"],
    status: json["status"],
    data:
        json["data"] == null
            ? []
            : List<dynamic>.from(json["data"]!.map((x) => x)),
    message: json["message"],
  );

  bool get isSuccess => status == true;
  bool get isError => status == false;

  String get error {
    if (status == false) {
      return message.toString();
    }
    return '';
  }
}
