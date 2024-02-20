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

  Message(
      {required this.id,
      required this.ownerId,
      required this.ownerImage,
      required this.receiverId,
      required this.type,
      required this.text,
      required this.image,
      required this.video,
      required this.time});

  Message.fromJson(Map<Object?, Object?> json)
      : id = json['id'].toString(),
        ownerId = json['owner_id'].toString(),
        ownerImage = json['owner_image'].toString(),
        receiverId = json['receiver_id'].toString(),
        text = json['text'].toString(),
        image = json['image'].toString(),
        video = json['video'].toString(),
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
      'video': video
    };
  }
}

enum MessageType { text, photo, video }
