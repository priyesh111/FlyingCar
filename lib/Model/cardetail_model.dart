// To parse this JSON data, do
//
//     final carDetailModel = carDetailModelFromJson(jsonString);

import 'dart:convert';

CarDetailModel carDetailModelFromJson(String str) => CarDetailModel.fromJson(json.decode(str));

String carDetailModelToJson(CarDetailModel data) => json.encode(data.toJson());

class CarDetailModel {
  String image;
  String modelName;
  String description;
  String maxTorque;
  String price;
  String transmission;
  String maxPower;
  String engineType;
  String varient;

  CarDetailModel({
    required this.image,
    required this.modelName,
    required this.description,
    required this.maxTorque,
    required this.price,
    required this.transmission,
    required this.maxPower,
    required this.engineType,
    required this.varient,
  });

  factory CarDetailModel.fromJson(Map<String, dynamic> json) => CarDetailModel(
    image: json["image"],
    modelName: json["ModelName"],
    description: json["Description"],
    maxTorque: json["MaxTorque"],
    price: json["price"],
    transmission: json["Transmission"],
    maxPower: json["MaxPower"],
    engineType: json["EngineType"],
    varient: json["Varient"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "ModelName": modelName,
    "Description": description,
    "MaxTorque": maxTorque,
    "price": price,
    "Transmission": transmission,
    "MaxPower": maxPower,
    "EngineType": engineType,
    "Varient": varient,
  };
}
