# api_http

A comprehensive HTTP API client library for Dart, designed to provide a clean and type-safe interface for making HTTP requests with support for various content types and mocking capabilities.

## Description

`api_http` is a part of the Coin Galaxy project that provides a robust HTTP client implementation with the following key features:

- **Type-safe HTTP methods**: GET, POST, PUT, DELETE, HEAD
- **Multiple content type support**: JSON, HTML, binary files, text, multipart form data
- **Comprehensive mocking system**: Full mock support for testing
- **Request/Response abstraction**: Clean separation of concerns
- **Timeout handling**: Built-in request timeout management
- **cURL command generation**: Debug-friendly curl command output

## Features

- [x] **HTTP Methods Support**
  - GET requests with query parameters
  - POST requests with various body types
  - PUT requests with body support
  - DELETE requests
  - HEAD requests

- [x] **Request Body Types**
  - JSON request bodies
  - Binary request bodies
  - Multipart form data with file uploads
  - Text request bodies

- [x] **Response Handling**
  - Automatic content type detection
  - JSON response parsing (Map and List)
  - HTML response handling
  - Binary file downloads with filename extraction
  - Text response processing

- [x] **Mock System**
  - Complete HTTP client mocking
  - Mock response generation
  - Mock cookie handling
  - Mock redirect information
  - JSON serialization for mocks

- [x] **Headers Management**
  - Type-safe header handling
  - Content-Type detection
  - Immutable header objects
  - Header manipulation utilities

- [x] **Utilities**
  - cURL command generation for debugging
  - Response piping utilities
  - Timeout management
  - File download and save functionality

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  api_http: ^0.0.2
```

## Usage

### Basic GET Request

```dart
import 'package:api_http/api_http.dart';

final request = GetRequestAcc(
  url: 'https://api.example.com/users',
  headers: RestHeaders({
    'Authorization': 'Bearer token',
  }),
  queryParameters: {'page': '1', 'limit': '10'},
);

final response = await Api.get(requestAcc: request);
print('Status: ${response.statusCode}');
print('Body: ${response.body}');
```

### POST Request with JSON Body

```dart
final request = PostRequestAcc(
  url: 'https://api.example.com/users',
  headers: RestHeaders({
    'Content-Type': 'application/json',
  }),
  body: JsonRequestBody({
    'name': 'John Doe',
    'email': 'john@example.com',
  }),
);

final response = await Api.post(requestAcc: request);
```

### File Upload with Multipart

```dart
final request = PostRequestAcc(
  url: 'https://api.example.com/upload',
  body: MultipartRequestBody([
    FieldsBodyPart({'name': 'John Doe'}),
    FileBodyPart(
      'avatar',
      File('path/to/image.jpg'),
      'image.jpg',
    ),
  ]),
);

final response = await Api.post(requestAcc: request);
```

### Handling File Downloads

```dart
final response = await Api.get(requestAcc: request);

if (response.body is FileResponseBody) {
  final fileBody = response.body as FileResponseBody;

  // Save to specific directory
  final path = await fileBody.saveToDirectory(
    '/downloads',
    prefix: 'user_avatar_',
  );

  // Or save to specific path
  await fileBody.saveToFile('/downloads/avatar.jpg');
}
```

### Mock Testing

```dart
// Create a mock response
final mockResponse = MockHttpClientResponse(
  statusCode: 200,
  reasonPhrase: 'OK',
  chunks: [utf8.encode('{"status": "success"}')],
  headers: MockHttpHeaders(
    headers: {'content-type': ['application/json']},
  ),
);

// Create mock unit for testing
final mockUnit = await GetMockUnit.makeMock(
  requestAcc: request,
  response: mockResponse,
);
```

## API Reference

### Core Classes

- **`Api`**: Main entry point for HTTP operations
- **`GetRequestAcc`**: GET request configuration
- **`PostRequestAcc`**: POST/PUT/DELETE request configuration
- **`ResponseAcc`**: HTTP response wrapper
- **`RestHeaders`**: Immutable header management

### Request Body Types

- **`JsonRequestBody`**: JSON payload
- **`BinaryRequestBody`**: Binary data
- **`MultipartRequestBody`**: Form data with files
- **`TextRequestBody`**: Plain text

### Response Body Types

- **`MapJsonResponseBody`**: JSON object responses
- **`ListJsonResponseBody`**: JSON array responses
- **`HtmlResponseBody`**: HTML content
- **`FileResponseBody`**: Binary file downloads
- **`TextResponseBody`**: Plain text responses

### Mock Classes

- **`MockHttpClientResponse`**: Mock HTTP response
- **`MockHttpHeaders`**: Mock HTTP headers
- **`MockCookie`**: Mock cookie handling
- **`MockRedirectInfo`**: Mock redirect information
- **`GetMockUnit`**, **`PostMockUnit`**, etc.: Method-specific mock units
