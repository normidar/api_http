import 'package:api_http/api_http.dart';

void main() async {
  print('=== API HTTP Library Example ===\n');

  // GET request example
  await getExample();

  // POST request example
  await postExample();

  // Request with headers example
  await headerExample();

  // Request with query parameters example
  await queryParameterExample();
}

/// Basic GET request example
Future<void> getExample() async {
  print('--- GET Request Example ---');

  try {
    final request = GetRequestAcc(
      url: 'https://jsonplaceholder.typicode.com/posts/1',
    );

    final response = await Api.get(requestAcc: request);

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    print('Curl Command: ${request.toCurlCommand()}');
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

/// Request with custom headers example
Future<void> headerExample() async {
  print('--- Request with Headers Example ---');

  try {
    final headers = {
      'Authorization': 'Bearer your-token-here',
      'User-Agent': 'API-HTTP-Library/1.0',
    };

    final request = GetRequestAcc(
      url: 'https://jsonplaceholder.typicode.com/posts/1',
      headers: headers,
    );

    final response = await Api.get(requestAcc: request);

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    print('Curl Command: ${request.toCurlCommand()}');
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

/// POST request with JSON body example
Future<void> postExample() async {
  print('--- POST Request Example ---');

  try {
    final request = PostRequestAcc(
      url: 'https://jsonplaceholder.typicode.com/posts',
      body: JsonRequestBody({
        'title': 'API HTTP Library Test',
        'body': 'This is a test post from api_http library',
        'userId': 1,
      }),
    );

    final response = await Api.post(requestAcc: request);

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    print('Curl Command: ${request.toCurlCommand()}');
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

/// Request with query parameters example
Future<void> queryParameterExample() async {
  print('--- Request with Query Parameters Example ---');

  try {
    final request = GetRequestAcc(
      url: 'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {
        'userId': '1',
        '_limit': '3',
      },
    );

    final response = await Api.get(requestAcc: request);

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    print('Curl Command: ${request.toCurlCommand()}');
  } catch (e) {
    print('Error: $e');
  }

  print('');
}
