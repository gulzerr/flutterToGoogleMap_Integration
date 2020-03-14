import 'package:json_annotation/json_annotation.dart';
import "location.dart";
part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    String name;
    Location location;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
