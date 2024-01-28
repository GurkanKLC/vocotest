class ApiReturnValue{
  Map<String,dynamic>? data;
  bool? dataStatus;
  int? statusCode;
  String? statusMessage;
  ApiReturnValue({this.data, this.dataStatus,this.statusCode,this.statusMessage});

  ApiReturnValue.noParameter();

  @override
  String toString() {
    return 'ApiReturnValue{data: $data, dataStatus: $dataStatus ,statusCode: $statusCode, statusMessage: $statusMessage}';
  }
}
