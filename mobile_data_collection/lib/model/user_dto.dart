import 'package:mobile_data_collection/model/user.dart';

class UserDto {
     String? email;
     String? prenom;
     String? nom;
     String? username;
     String? role;
     

     UserDto({this.email, this.prenom, this.nom, this.username, this.role});

    factory UserDto.fromJson(Map<String, dynamic> json) {
      return UserDto(
        email: json['email'],
        prenom: json['prenom'],
        nom: json['nom'],
        username: json['username'],
        role: json['role'],

      );
    }
}