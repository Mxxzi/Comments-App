class Post {
  int? id;
  String? name;
  String? email;
  String? body;

  Post({this.id, this.name, this.email, this.body});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    body = json['body'];
  }
}
