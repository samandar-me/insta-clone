class Message {
  String? id;
  String? ownerId;
  String? ownerImage;
  String? receiverId;
  String? text;
  String? image;
  String? video;
  MessageType? type;
  String? time;
  String? imageId;
  String? videoId;

  Message(
      {required this.id,
      required this.ownerId,
      required this.ownerImage,
      required this.receiverId,
      required this.type,
      required this.text,
      required this.image,
      required this.video,
      required this.imageId,
      required this.videoId,
      required this.time});

  Message.fromJson(Map<Object?, Object?> json)
      : id = json['id'].toString(),
        ownerId = json['owner_id'].toString(),
        ownerImage = json['owner_image'].toString(),
        receiverId = json['receiver_id'].toString(),
        text = json['text'].toString(),
        image = json['image'].toString(),
        video = json['video'].toString(),
        imageId = json['image_id'].toString(),
        videoId = json['video_id'].toString(),
        type = MessageType.values.byName(json['type'].toString()),
        time = json['time'].toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'owner_image': ownerImage,
      'receiver_id': receiverId,
      'type': type?.name,
      'time': time,
      'text': text,
      'image': image,
      'video': video,
      'video_id': videoId,
      'image_id': imageId,
    };
  }
}

enum MessageType { text, photo, video }
