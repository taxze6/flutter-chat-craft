class UserStory {
  int? storyId;
  int? ownerId;
  String? content;
  List<String>? media;
  int? type;

  UserStory({
    this.storyId,
    this.ownerId,
    this.content,
    this.media,
    this.type,
  });

  UserStory.fromJson(Map<String, dynamic> json)
      : storyId = json["ID"],
        ownerId = json['owner_id'],
        content = json['content'],
        media = json['media'].split(','),
        type = json['type'];

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'content': content,
      'media': media?.join(','),
      'type': type,
    };
  }

  @override
  String toString() {
    return 'UserStory{ownerId: $ownerId, content: $content, media: $media, type: $type}';
  }
}
