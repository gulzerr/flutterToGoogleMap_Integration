import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
    Location();

    num latitude;
    num longitude;
    
    factory Location.fromJson(Map<String,dynamic> json) => _$LocationFromJson(json);
    Map<String, dynamic> toJson() => _$LocationToJson(this);
}
