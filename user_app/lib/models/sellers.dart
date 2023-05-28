class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerEmail;
  String? sellerAvtar;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvtar,
    this.sellerEmail,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvtar = json["sellerAvtar"];
    sellerEmail = json["sellerEmail"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerAvtar"] = this.sellerAvtar;
    data["sellerEmail"] = this.sellerEmail;
    return data;
  }
}
