class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final PaginationInfo? pagination;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>)
          : (json['meta'] != null
              ? PaginationInfo.fromJson(json['meta'] as Map<String, dynamic>)
              : null),
    );
  }

  bool get isSuccess => success;
  bool get hasErrors => errors != null && errors!.isNotEmpty;
  bool get hasPagination => pagination != null;
}

class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, int fallback) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    final currentPage = parseInt(json['current_page'], 1);
    final lastPage = parseInt(json['last_page'], 1);

    return PaginationInfo(
      currentPage: currentPage,
      perPage: parseInt(json['per_page'], 15),
      total: parseInt(json['total'], 0),
      lastPage: lastPage,
      hasMorePages: currentPage < lastPage,
    );
  }
}
