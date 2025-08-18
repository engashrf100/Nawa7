import 'package:nawah/core/network/api_service.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
  Future<AppBranch> getBranchById(int id);
  Future<AppBranches> getBranches(int page);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<HomeModel> getHomeData() async {
    final response = await apiService.getHome();
    return response.data;
  }

  @override
  Future<AppBranch> getBranchById(int id) async {
    final response = await apiService.getBranchById(id);
    return response.data;
  }

  @override
  Future<AppBranches> getBranches(int page) async {
    final response = await apiService.getBranches(page: page, limit: 5);
    return response.data;
  }
}
