enum ContentType {
  json,
  html,
  binary,
  text,
  multipart,
  image,
  other;

  static ContentType fromString(String contentType) {
    if (contentType.contains('application/json')) return ContentType.json;
    if (contentType.contains('text/html')) return ContentType.html;
    if (contentType.contains('application/octet-stream')) {
      return ContentType.binary;
    }
    if (contentType.contains('text/plain')) return ContentType.text;
    if (contentType.contains('multipart/form-data')) {
      return ContentType.multipart;
    }
    if (contentType.contains('image/')) {
      return ContentType.image;
    }
    return ContentType.other;
  }
}
