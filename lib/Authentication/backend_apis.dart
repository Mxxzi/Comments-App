import 'package:http/http.dart' as http;
class BackendApis {
    Future<String> getComments() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/comments");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}