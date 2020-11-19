class APIResponse<T>{
  T data;
  bool error = false;
  String errorMessage;

  APIResponse({
    this.data,
    this.error = false,
    this.errorMessage
  });
}