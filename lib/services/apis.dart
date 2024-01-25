import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_first_project/modals/uploadImage.dart';

class Apis{
 static const String apiurl = "https://apiwangwang.zimblecode.com/api/upload/image-upload?";
 static Future<UploadImage> uploaduserimage({String? imageurl})async{
  var dio = Dio();
  var map = FormData.fromMap({
"image": await MultipartFile.fromFile(imageurl!)
  });
 try {Response response =  await dio.post(apiurl,data: map);
  return UploadImage.fromJson(jsonDecode(response.toString()));
  } on DioException {
    throw const SocketException("please hit the Api");
  }
  
}
}