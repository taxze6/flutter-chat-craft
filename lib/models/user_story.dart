class UserStory {
  int? storyId;
  int? ownerId;
  String? content;
  List<String>? media;
  int? type;
  List<UserStoryLike>? storyLikes;

  UserStory({
    this.storyId,
    this.ownerId,
    this.content,
    this.media,
    this.type,
    this.storyLikes,
  });

  UserStory.fromJson(Map<String, dynamic> json)
      : storyId = json["ID"],
        ownerId = json['owner_id'],
        content = json['content'],
        media = json['media'] != null ? json['media'].split(',') : [],
        type = json['type'];

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'content': content,
      'media': media?.join(','),
      'type': type,
      'storyLikes': storyLikes,
    };
  }

  @override
  String toString() {
    return 'UserStory{ownerId: $ownerId, content: $content, media: $media, type: $type,storyLikes:$storyLikes}';
  }
}

class UserStoryLike {
  int? storyId;
  int? ownerId;

  UserStoryLike({
    this.storyId,
    this.ownerId,
  });

  UserStoryLike.fromJson(Map<String, dynamic> json)
      : storyId = json["like_owner_id"],
        ownerId = json['user_story_id'];

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'ownerId': ownerId,
    };
  }

  @override
  String toString() {
    return 'UserStoryLike{storyId:$storyId,ownerId: $ownerId}';
  }
}
