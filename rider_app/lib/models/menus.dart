import 'dart:convert';

class Menus {
  String? menuId;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  String? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus(
      {this.menuId,
      this.menuInfo,
      this.menuTitle,
      this.sellerUID,
      this.publishedDate,
      this.status,
      this.thumbnailUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json["menuId"];
    sellerUID = json["sellerUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];

    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    // publishedDate = json['publishedDate'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuId"] = menuId;
    data["sellerUID"] = sellerUID;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    return data;
  }
}
