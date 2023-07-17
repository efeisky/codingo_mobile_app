class ResponseData {
  int availabilityStatus;
  List<Content>? content;

  ResponseData({required this.availabilityStatus, this.content});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      availabilityStatus: json['availabilityStatus'],
      content: json['Content'] != null
          ? List<Content>.from(json['Content'].map((x) => Content.fromJson(x)))
          : null,
    );
  }
}

class Content {
  int id;
  String username;

  Content({required this.id, required this.username});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      username: json['username'],
    );
  }
}
