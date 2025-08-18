import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/core/network/dio_exception.dart';
import 'package:nawah/core/services/network_info.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/home/data/datasource/home_remote_data_source.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/home/presentation/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.homeRemoteDataSource,
    required this.networkInfo,
    s,
  });

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    try {
      final homeData = await homeRemoteDataSource.getHomeData();
      return Right(homeData);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to load home data: $error'));
    }
  }

  @override
  Future<Either<Failure, AppBranch>> getBranchById(int id) async {
    try {
      final branchesData = await homeRemoteDataSource.getBranchById(id);
      return Right(branchesData);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to load branches data: $error'));
    }
  }

  @override
  Future<Either<Failure, AppBranches>> getBranches(int page) async {
    try {
      final branchesData = await homeRemoteDataSource.getBranches(page);
      return Right(branchesData);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to load branches data: $error'));
    }
  }
}
