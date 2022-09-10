class HobbyModel {
  String? title;
  List<Subtitles>? subtitles;

  HobbyModel({this.title, this.subtitles});

  HobbyModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['subtitles'] != null) {
      subtitles = <Subtitles>[];
      json['subtitles'].forEach((v) {
        subtitles!.add(Subtitles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (subtitles != null) {
      data['subtitles'] = subtitles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subtitles {
  String? level;
  String? subtitle;

  Subtitles({this.level, this.subtitle});

  Subtitles.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['subtitle'] = subtitle;
    return data;
  }
}
