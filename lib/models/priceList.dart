// To parse this JSON data, do
//
//     final holidayList = holidayListFromJson(jsonString);

import 'dart:convert';

List<PriceListData> PriceListDataFromJson(String str) => List<PriceListData>.from(json.decode(str).map((x) => PriceListData.fromJson(x)));

String PriceListDataToJson(List<PriceListData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PriceListData {
  PriceListData({
    required this.name,
    required this.weight,
    required this.mrp,
    required this.selling
  });

  String name;
  String weight;
  int mrp;
  int selling;

  factory PriceListData.fromJson(Map<String, dynamic> json) => PriceListData(
    name: json["name"],
    weight: json["weight"],
    mrp: json["mrp"] ?? 0,
    selling: json["selling"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "weight": weight,
    "mrp": mrp,
    "selling" : selling
  };
}
