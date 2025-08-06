import 'dart:async';
import 'dart:convert';

import 'package:api_http/api_http.dart';
import 'package:http/http.dart' as http;

class MethodUtils {
  // タイムアウト設定（秒）
  static const int requestTimeout = 60; // 60秒

  static Future<ResponseAcc> sendGet({
    required GetRequestAcc requestAcc,
    required http.Client client,
  }) async {
    final queryParameters = requestAcc.queryParameters;
    var url = requestAcc.url;
    if (queryParameters != null) {
      url = '$url?${Uri(queryParameters: queryParameters).query}';
    }
    final uri = Uri.parse(url);

    final headers = requestAcc.headers ?? {};

    final request = http.Request('GET', uri);

    request.headers.addAll(headers);

    final response = await client.send(request);
    return ResponseAcc.fromStreamedResponse(response);
  }

  static Future<bool> sendHead({
    required GetRequestAcc requestAcc,
    required http.Client client,
  }) async {
    final queryParameters = requestAcc.queryParameters;
    var url = requestAcc.url;
    if (queryParameters != null) {
      url = '$url?${Uri(queryParameters: queryParameters).query}';
    }
    final uri = Uri.parse(url);

    final headers = requestAcc.headers ?? {};

    final request = http.Request('HEAD', uri);

    request.headers.addAll(headers);

    final response = await client.send(request);

    return response.statusCode == 200;
  }

  static Future<ResponseAcc> sendPost({
    required String method,
    required PostRequestAcc requestAcc,
    required http.Client client,
  }) async {
    final requestBody = requestAcc.body;

    final queryParameters = requestAcc.queryParameters;
    var url = requestAcc.url;
    if (queryParameters != null) {
      url = '$url?${Uri(queryParameters: queryParameters).query}';
    }
    final uri = Uri.parse(url);

    final headers = {
      ...(requestAcc.headers ?? {}),
      ...(requestBody?.styleHeaders ?? {}),
    };

    switch (requestBody) {
      case JsonRequestBody():
        final request = http.Request(method, uri);
        request.headers.addAll(headers);
        request.body = json.encode(requestBody.json);
        final response = await client.send(request);
        return ResponseAcc.fromStreamedResponse(response);
      case BinaryRequestBody():
        final request = http.Request(method, uri);
        request.headers.addAll(headers);
        request.bodyBytes = requestBody.binary;
        final response = await client.send(request);
        return ResponseAcc.fromStreamedResponse(response);
      case MultipartRequestBody():
        final request = http.MultipartRequest(method, uri);
        request.headers.addAll(headers);

        for (final part in requestBody.bodyParts) {
          switch (part) {
            case FieldsBodyPart():
              request.fields.addAll(part.json);
            case FileBodyPart():
              request.files.add(
                await http.MultipartFile.fromPath(
                  part.fieldName,
                  part.file.path,
                ),
              );
          }
        }
        final response = await client.send(request);
        return ResponseAcc.fromStreamedResponse(response);
      case null:
        final request = http.Request(method, uri);
        request.headers.addAll(headers);
        final response = await client.send(request);
        return ResponseAcc.fromStreamedResponse(response);
    }
  }
}
