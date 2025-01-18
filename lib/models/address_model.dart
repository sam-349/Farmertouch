// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    String? name;
    String? street;
    String? isoCountryCode;
    String? country;
    String? postalCode;
    String? administrativeArea;
    String? subAdministrativeArea;
    String? locality;
    String? subLocality;
    String? thoroughfare;
    String? subThoroughfare;

    Address({
        this.name,
        this.street,
        this.isoCountryCode,
        this.country,
        this.postalCode,
        this.administrativeArea,
        this.subAdministrativeArea,
        this.locality,
        this.subLocality,
        this.thoroughfare,
        this.subThoroughfare,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        street: json["street"],
        isoCountryCode: json["isoCountryCode"],
        country: json["country"],
        postalCode: json["postalCode"],
        administrativeArea: json["administrativeArea"],
        subAdministrativeArea: json["subAdministrativeArea"],
        locality: json["locality"],
        subLocality: json["subLocality"],
        thoroughfare: json["thoroughfare"],
        subThoroughfare: json["subThoroughfare"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "street": street,
        "isoCountryCode": isoCountryCode,
        "country": country,
        "postalCode": postalCode,
        "administrativeArea": administrativeArea,
        "subAdministrativeArea": subAdministrativeArea,
        "locality": locality,
        "subLocality": subLocality,
        "thoroughfare": thoroughfare,
        "subThoroughfare": subThoroughfare,
    };
}
