class UserStory {
  int? storyId;
  int? ownerId;
  String? content;
  List<String>? media;
  int? type;
  List<UserStoryLike>? storyLikes;
  List<UserStoryComment>? storyComments;

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
    return 'UserStory{ownerId: $ownerId, content: $content, media: $media, type: $type,storyLikes:$storyLikes,storyComments:$storyComments}';
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

class UserStoryComment {
  int? userStoryId;
  int? commentOwnerId;
  String? commentContent;
  int? type;
  String? userAvatar;

  UserStoryComment({
    this.userStoryId,
    this.commentOwnerId,
    this.commentContent,
    this.type,
    this.userAvatar,
  });

  UserStoryComment.fromJson(Map<String, dynamic> json)
      : userStoryId = json["story_comment"]["user_story_id"],
        commentOwnerId = json["story_comment"]['comment_owner_id'],
        commentContent = json["story_comment"]["comment_content"],
        type = json["story_comment"]['type'],
        userAvatar = json["user_avatar"];

  Map<String, dynamic> toJson() {
    return {
      'user_story_id': userStoryId,
      'comment_owner_id': commentOwnerId,
      'comment_content': commentContent,
      'type': type,
      'userAvatar': userAvatar,
    };
  }

  @override
  String toString() {
    return 'UserStoryComment{user_story_id: $userStoryId,comment_owner_id: $commentOwnerId,comment_content: $commentContent,type: $type,userAvatar:$userAvatar}';
  }
}

class UserStoryCommentType {
  static const text = 101;
  static const image = 102;
}
