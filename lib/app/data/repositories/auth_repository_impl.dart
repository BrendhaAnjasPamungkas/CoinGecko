import 'package:blockchain/app/data/datasource/auth_datasource.dart';
import 'package:blockchain/app/domain/entities/user.dart';
import 'package:blockchain/app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    return await datasource.login(email, password); // Panggil login di AuthDatasource
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    return await datasource.register(email, password); // Panggil register di AuthDatasource
  }

  @override
  Future<void> logout() async {
    return await datasource.logout();
  }
  
  @override
  Future<void> addUserToFirestore(String uid, String name, String email) async {
    try {
      await datasource.addUserToFirestore(uid, name, email); // Pastikan datasource ada untuk handle Firestore
    } catch (e) {
      throw Exception('Error adding user to Firestore: $e');
    }
}}