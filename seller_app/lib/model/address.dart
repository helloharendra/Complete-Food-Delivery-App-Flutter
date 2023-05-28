import "package:flutter/material.dart";

class Address {
  String? name;
  String? phoneNumber;
  String? flatNumber;

  String? city;
  String? state;
  String? fullAddress;
  String? lat;
  String? lng;

  Address(
      {this.name,
      this.phoneNumber,
      this.flatNumber,
      this.city,
      this.state,
      this.fullAddress,
      this.lat,
      this.lng});

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    fullAddress = json['fullAddress'];
    lat = json['lat'];
    lng = json['lng'];
  }

  get longitude => '';

  get lattitude => '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['flatNumber'] = this.flatNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['fullAddress'] = this.fullAddress;
    data['lat'] = this.lat;
    data['lng'] = this.lng;

    return data;
  }
}
