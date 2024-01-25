// ignore: file_names
class UploadImage {
  UploadImage({
    required this.apiId,
    required this.statusCode,
    required this.message,
    required this.data,
  });
  late final String apiId;
  late final int statusCode;
  late final String message;
  late final Data data;
  
  UploadImage.fromJson(Map<String, dynamic> json){
    apiId = json['apiId'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final putdata = <String, dynamic>{};
    putdata['apiId'] = apiId;
    putdata['statusCode'] = statusCode;
    putdata['message'] = message;
    putdata['data'] = data.toJson();
    return putdata;
  }
}

class Data {
  Data({
    required this.url,
  });
  late final String url;
  
  Data.fromJson(Map<String, dynamic> json){
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final putdata = <String, dynamic>{};
    putdata['url'] = url;
    return putdata;
  }
}