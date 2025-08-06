import 'package:api_http/api_http.dart';
import 'package:test/test.dart';

void main() {
  test('Test null body', () async {
    final request = PostRequestAcc(
      url: 'https://jsonplaceholder.typicode.com/posts/1',
    );
    final response = await Api.post(requestAcc: request);
    expect(response.body, isA<MapJsonResponseBody>());
  });
}
