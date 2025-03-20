
class MessageModel {
  int? id;
  String? sender_username;
  String? content;
  String? media;
  String? media_type;
  int? created_at;
  double? media_aspect_ratio;
  String? thumbnail;

  bool isMine = false;
  MediaTypeModel? mediaTypeModel;

  MessageModel();

  MessageModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    sender_username = json['sender_username'];
    content = json['content'];
    media = json['media'];
    media_type = json['media_type'];
    created_at = json['created_at'];
    media_aspect_ratio = json['media_aspect_ratio'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_username': sender_username,
    'content': content,
    'media': media,
    'media_type': media_type,
    'created_at': created_at,
    'media_aspect_ratio': media_aspect_ratio,
  };

}

enum MediaTypeModel {
  video,
  audio,
  image,
  file,
}

extension MediaTypeExtension on MediaTypeModel {
  bool get isVideo => this == MediaTypeModel.video;
  bool get isAudio => this == MediaTypeModel.audio;
  bool get isImage => this == MediaTypeModel.image;
  bool get isFile => this == MediaTypeModel.file;
}

extension MediaTypeModelExtension on String? {
  MediaTypeModel? get mediaTypeModelFromString {
    if (this == null) {
      return null;
    }
    switch (this) {
      case 'video':
        return MediaTypeModel.video;
      case 'audio':
        return MediaTypeModel.audio;
      case 'image':
        return MediaTypeModel.image;
      case 'file':
    }
    return null;
  }

}
