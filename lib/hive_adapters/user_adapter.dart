import 'package:hive/hive.dart';
import '../features/auth/data/models/user_model.dart';

part 'user_adapter.g.dart';

@HiveType(typeId: 2)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  // @HiveField(3)
  // final String role; // e.g., 'dairy_manager'

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    // required this.role,
  });

  // Convert from UserModel
  factory UserHiveModel.fromModel(UserModel model) {
    return UserHiveModel(
      id: model.id,
      name: model.name,
      email: model.email,
      // role: model.role,
    );
  }

  // Convert to UserModel
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email, 
      phone: '', 
      token: '',
      // role: role,
    );
  }
}
