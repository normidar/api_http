import 'dart:convert';

import 'package:api_http/api_http.dart';
import 'package:meta/meta.dart';

@immutable
class PostRequestAcc extends RequestAcc {
  const PostRequestAcc({
    required this.url,
    Map<String, String>? headers,
    this.queryParameters,
    this.body,
  }) : _headers = headers;

  factory PostRequestAcc.fromJson(
    Map<String, dynamic> json,
  ) =>
      PostRequestAcc(
        url: json['url'] as String,
        headers: json['headers'] as Map<String, String>?,
        queryParameters: json['queryParameters'] as Map<String, String>?,
        body: json['body'] != null
            ? RequestBody.fromJson(json['body'] as Map<String, dynamic>)
            : null,
      );

  final String url;

  final Map<String, String>? _headers;

  final Map<String, String>? queryParameters;

  final RequestBody? body;

  @override
  int get hashCode => Object.hashAll([url, _headers, queryParameters, body]);

  Map<String, String>? get headers {
    if (_headers == null) return null;
    return _headers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostRequestAcc &&
          other.url == url &&
          other._headers == _headers &&
          (other.queryParameters ?? {}) == (queryParameters ?? {}) &&
          other.body == body);

  PostRequestAcc copyWith({
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    RequestBody? body,
  }) =>
      PostRequestAcc(
        url: url,
        headers: headers ?? _headers,
        queryParameters: queryParameters ?? this.queryParameters,
        body: body ?? this.body,
      );

  @override
  String toCurlCommand() {
    final queries = queryParameters?.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    final finalUrl = queries != null ? '$url?$queries' : url;

    final headerStrings = <String>[];

    // Add custom headers
    if (headers != null) {
      headerStrings.addAll(
        headers!.entries.map((e) => '-H "${e.key}: ${e.value}"'),
      );
    }

    // Add body-specific headers and data
    final bodyParts = <String>[];
    if (body != null) {
      // Add content-type header from body
      final bodyHeaders = body!.styleHeaders;
      for (final entry in bodyHeaders.entries) {
        headerStrings.add('-H "${entry.key}: ${entry.value}"');
      }

      // Add body data based on type
      switch (body) {
        case JsonRequestBody():
          final jsonBody = body! as JsonRequestBody;
          final jsonString = jsonEncode(jsonBody.json);
          bodyParts.add("-d '$jsonString'");
        case BinaryRequestBody():
          final binaryBody = body! as BinaryRequestBody;
          bodyParts.add(
            '--data-binary @<(echo -n "${base64Encode(binaryBody.binary)}" | base64 -d)',
          );
        case MultipartRequestBody():
          final multipartBody = body! as MultipartRequestBody;
          for (final part in multipartBody.bodyParts) {
            switch (part) {
              case FieldsBodyPart():
                final fieldsPart = part;
                for (final entry in fieldsPart.json.entries) {
                  bodyParts.add('-F "${entry.key}=${entry.value}"');
                }
              case FileBodyPart():
                final filePart = part;
                bodyParts
                    .add('-F "${filePart.fieldName}=@${filePart.file.path}"');
            }
          }
        default:
          bodyParts.add("-d '${body!.toJson()}'");
      }
    }

    final command = [
      'curl "$finalUrl"',
      ...headerStrings,
      '-X POST',
      ...bodyParts,
    ];

    return command.join(' \\\n  ');
  }

  @override
  Map<String, dynamic> toJson() => {
        'url': url,
        'headers': _headers,
        'queryParameters': queryParameters,
        'body': body?.toJson(),
      };

  @override
  String toString() => 'PostRequestAcc(url: $url, headers: $_headers,'
      ' queryParameters: $queryParameters, data: $body)';
}
