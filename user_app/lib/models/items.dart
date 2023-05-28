class Items {
  String? menuId;
  String? sellerUID;
  String? itemId;
  String? title;
  String? shortInfo;
  String? publishedDate;
  String? thumbnailUrl;
  String? sellerName;
  String? longDescription;
  String? status;
  int? price;

  Items(
      {this.menuId,
      this.sellerUID,
      this.itemId,
      this.title,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      // this.sellerName,
      this.longDescription,
      this.status,
      this.price});

  Items.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    sellerUID = json['sellerUID'];
    title = json['title'];
    itemId = json['itemId'];
    shortInfo = json['shortInfo'];
    // publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];

    // sellerName = json['sellerName'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuId'] = menuId;
    data['sellerUID'] = sellerUID;
    data['title'] = title;
    data['itemId'] = itemId;

    data['shortInfo'] = shortInfo;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    // data['sellerName']=sellerName;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['price'] = price;

    return data;
  }
}
