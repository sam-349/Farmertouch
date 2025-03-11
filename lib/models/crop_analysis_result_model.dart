// To parse this JSON data, do
//
//     final analysisResultModel = analysisResultModelFromJson(jsonString);

import 'dart:convert';

AnalysisResultModel analysisResultModelFromJson(String str) =>
    AnalysisResultModel.fromJson(json.decode(str));

String analysisResultModelToJson(AnalysisResultModel data) =>
    json.encode(data.toJson());

class AnalysisResultModel {
  String? accessToken;
  String? modelVersion;
  dynamic customId;
  Input? input;
  Result? result;
  String? status;
  bool? slaCompliantClient;
  bool? slaCompliantSystem;
  double? created;
  double? completed;

  AnalysisResultModel({
    this.accessToken,
    this.modelVersion,
    this.customId,
    this.input,
    this.result,
    this.status,
    this.slaCompliantClient,
    this.slaCompliantSystem,
    this.created,
    this.completed,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) =>
      AnalysisResultModel(
        accessToken: json["access_token"],
        modelVersion: json["model_version"],
        customId: json["custom_id"],
        input: json["input"] == null ? null : Input.fromJson(json["input"]),
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        status: json["status"],
        slaCompliantClient: json["sla_compliant_client"],
        slaCompliantSystem: json["sla_compliant_system"],
        created: json["created"]?.toDouble(),
        completed: json["completed"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "model_version": modelVersion,
        "custom_id": customId,
        "input": input?.toJson(),
        "result": result?.toJson(),
        "status": status,
        "sla_compliant_client": slaCompliantClient,
        "sla_compliant_system": slaCompliantSystem,
        "created": created,
        "completed": completed,
      };
}

class Input {
  double? latitude;
  double? longitude;
  bool? similarImages;
  String? health;
  List<String>? images;
  DateTime? datetime;

  Input({
    this.latitude,
    this.longitude,
    this.similarImages,
    this.health,
    this.images,
    this.datetime,
  });

  factory Input.fromJson(Map<String, dynamic> json) => Input(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        similarImages: json["similar_images"],
        health: json["health"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "similar_images": similarImages,
        "health": health,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "datetime": datetime?.toIso8601String(),
      };
}

class Result {
  Disease? disease;
  Is? isHealthy;
  Is? isPlant;

  Result({
    this.disease,
    this.isHealthy,
    this.isPlant,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        disease:
            json["disease"] == null ? null : Disease.fromJson(json["disease"]),
        isHealthy:
            json["is_healthy"] == null ? null : Is.fromJson(json["is_healthy"]),
        isPlant:
            json["is_plant"] == null ? null : Is.fromJson(json["is_plant"]),
      );

  Map<String, dynamic> toJson() => {
        "disease": disease?.toJson(),
        "is_healthy": isHealthy?.toJson(),
        "is_plant": isPlant?.toJson(),
      };
}

class Disease {
  List<Suggestion>? suggestions;

  Disease({
    this.suggestions,
  });

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
        suggestions: json["suggestions"] == null
            ? []
            : List<Suggestion>.from(
                json["suggestions"]!.map((x) => Suggestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "suggestions": suggestions == null
            ? []
            : List<dynamic>.from(suggestions!.map((x) => x.toJson())),
      };
}

class Suggestion {
  String? id;
  String? name;
  double? probability;
  List<SimilarImage>? similarImages;
  Details? details;

  Suggestion({
    this.id,
    this.name,
    this.probability,
    this.similarImages,
    this.details,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        name: json["name"],
        probability: json["probability"]?.toDouble(),
        similarImages: json["similar_images"] == null
            ? []
            : List<SimilarImage>.from(
                json["similar_images"]!.map((x) => SimilarImage.fromJson(x))),
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "probability": probability,
        "similar_images": similarImages == null
            ? []
            : List<dynamic>.from(similarImages!.map((x) => x.toJson())),
        "details": details?.toJson(),
      };
}

class Details {
  String? language;
  String? entityId;

  Details({
    this.language,
    this.entityId,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        language: json["language"],
        entityId: json["entity_id"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "entity_id": entityId,
      };
}

class SimilarImage {
  String? id;
  String? url;
  double? similarity;
  String? urlSmall;
  String? licenseName;
  String? licenseUrl;
  String? citation;

  SimilarImage({
    this.id,
    this.url,
    this.similarity,
    this.urlSmall,
    this.licenseName,
    this.licenseUrl,
    this.citation,
  });

  factory SimilarImage.fromJson(Map<String, dynamic> json) => SimilarImage(
        id: json["id"],
        url: json["url"],
        similarity: json["similarity"]?.toDouble(),
        urlSmall: json["url_small"],
        licenseName: json["license_name"],
        licenseUrl: json["license_url"],
        citation: json["citation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "similarity": similarity,
        "url_small": urlSmall,
        "license_name": licenseName,
        "license_url": licenseUrl,
        "citation": citation,
      };
}

class Is {
  bool? binary;
  double? threshold;
  double? probability;

  Is({
    this.binary,
    this.threshold,
    this.probability,
  });

  factory Is.fromJson(Map<String, dynamic> json) => Is(
        binary: json["binary"],
        threshold: json["threshold"]?.toDouble(),
        probability: json["probability"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "binary": binary,
        "threshold": threshold,
        "probability": probability,
      };
}
