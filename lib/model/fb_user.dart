class FbUser {
  String? uid;
  String? image;
  String? username;
  String? email;
  String? password;
  String? bio;
  int? postCount;
  int? followerCount;
  int? followingCount;

  FbUser.user(
  {
    required this.uid,
    required this.image,
    required this.username,
    required this.email,
    required this.password,
    required this.bio,
    required this.postCount,
    required this.followerCount,
    required this.followingCount
}
      );
  FbUser();

  FbUser.fromJson(Map<Object?, Object?> json) :
        uid = json['uid'].toString(),
        image = json['image'].toString(),
        email = json['email'].toString(),
        username = json['username'].toString(),
        bio = json['bio'].toString(),
        password = json['password'].toString(),
        postCount = int.tryParse(json['post_count'].toString()) ?? 0, /// 3 tasi
        followingCount = int.tryParse(json['following_count'].toString()) ?? 0,
        followerCount = int.tryParse(json['follower_count'].toString()) ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'image': image,
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'post_count': postCount, /// 3 tasi
      'following_count': followingCount,
      'follower_count': followerCount
    };
  }
}