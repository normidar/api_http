import 'package:api_http/api_http.dart';

ContentType getContentType(Map<String, String> headers) {
  final contentType = headers['content-type'];
  if (contentType == null) {
    return ContentType.other;
  }
  return ContentType.fromString(contentType);
}
