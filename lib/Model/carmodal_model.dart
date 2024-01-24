// To parse this JSON data, do
//
//     final carModal = carModalFromJson(jsonString);

import 'dart:convert';

Map<String, CarModal> carModalFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, CarModal>(k, CarModal.fromJson(v)));

String carModalToJson(Map<String, CarModal> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class CarModal {
  String carImage;
  String carcompany;
  String cardescription;
  String carname;
  String carprice;

  CarModal({
    required this.carImage,
    required this.carcompany,
    required this.cardescription,
    required this.carname,
    required this.carprice,
  });

  factory CarModal.fromJson(Map<String, dynamic> json) => CarModal(
    carImage: json["carImage"],
    carcompany: json["carcompany"],
    cardescription: json["cardescription"],
    carname: json["carname"],
    carprice: json["carprice"],
  );

  Map<String, dynamic> toJson() => {
    "carImage": carImage,
    "carcompany": carcompany,
    "cardescription": cardescription,
    "carname": carname,
    "carprice": carprice,
  };
}
