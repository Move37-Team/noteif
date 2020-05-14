
class Note {
  int id;
  String title;
  String body;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'body': body
    };
    return map;
  }

  Note({this.id, this.title, this.body});

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
  }
}
