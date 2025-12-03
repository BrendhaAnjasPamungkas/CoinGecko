// ========== lib/injection.dart ==========
import 'package:blockchain/app/data/repositories/transaction_repository_impl.dart';
import 'package:blockchain/app/domain/repositories/transaction_repository.dart';
import 'package:blockchain/app/data/repositories/user_repository_impl.dart';
import 'package:blockchain/app/domain/repositories/user_repository.dart';
import 'package:blockchain/app/domain/usecase/transaction_usecase.dart';
import 'package:blockchain/app/domain/usecase/user_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Coin imports
import 'package:blockchain/app/data/datasource/coin_datasource.dart';
import 'package:blockchain/app/data/repositories/coin_repository_impl.dart';
import 'package:blockchain/app/domain/repositories/coin_repository.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';

// Auth imports
import 'package:blockchain/app/data/datasource/auth_datasource.dart';
import 'package:blockchain/app/data/repositories/auth_repository_impl.dart';
import 'package:blockchain/app/domain/repositories/auth_repository.dart';

// --- IMPORT USECASE BARU ---
import 'package:blockchain/app/domain/usecase/get_coin_chart_usecase.dart';

final GetIt sl = GetIt.instance;

void setup() {
  // =======================
  // External Dependencies
  // =======================
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // =======================
  // DataSources
  // =======================
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthDatasource(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<CoinDatasource>(
    () => CoinDatasource(client: sl<http.Client>()),
  );

  // =======================
  // Repositories
  // =======================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthDatasource>()),
  );
  sl.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(datasource: sl<CoinDatasource>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
        firestore: sl<FirebaseFirestore>(), auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(firestore: sl<FirebaseFirestore>()),
  );

  // =======================
  // UseCases
  // =======================
  sl.registerLazySingleton<GetMarketCoinsUsecase>(
    () => GetMarketCoinsUsecase(sl<CoinRepository>()),
  );
  sl.registerLazySingleton<UserUsecase>(
    () => UserUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<TransactionUseCase>(
    () => TransactionUseCase(
      transactionRepository: sl<TransactionRepository>(),
      userRepository: sl<UserRepository>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  // --- DAFTARKAN USECASE BARU ---
  sl.registerLazySingleton<GetCoinChartUsecase>(
    () => GetCoinChartUsecase(sl<CoinRepository>()),
  );
}