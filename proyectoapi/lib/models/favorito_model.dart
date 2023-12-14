class Favorito {
  String userId;
  String urls;

  Favorito({
    required this.userId,
    required this.urls,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'urls': urls,
    };
  }

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      userId: json['userId'],
      urls: json['urls'],
    );
  }
}
