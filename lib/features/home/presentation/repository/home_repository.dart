import 'package:dartz/dartz.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData();
  Future<Either<Failure, AppBranch>> getBranchById(int id);
  Future<Either<Failure, AppBranches>> getBranches(int page);
}


/*  

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key}) : super(key: key);

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Branch> _branches = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialBranches();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialBranches() {
    context.read<HomeCubit>().getBranches(page: 1);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreBranches();
    }
  }

  void _loadMoreBranches() {
    if (_hasMoreData && !_isLoadingMore) {
      _currentPage++;
      context.read<HomeCubit>().loadMoreBranches(page: _currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('branches_screen_title'.tr()),
        centerTitle: true,
      ),
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is BranchesLoaded) {
            setState(() {
              _branches = state.branches.branches ?? [];
              _isLoading = false;
              _hasMoreData = _checkHasMoreData(state.branches);
            });
          } else if (state is BranchesLoadedMore) {
            setState(() {
              if (state.branches.branches?.isNotEmpty == true) {
                _branches.addAll(state.branches.branches!);
              }
              _isLoadingMore = false;
              _hasMoreData = _checkHasMoreData(state.branches);
            });
          } else if (state is BranchesLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is BranchesLoadingMore) {
            setState(() {
              _isLoadingMore = true;
            });
          } else if (state is BranchesError) {
            setState(() {
              _isLoading = false;
              _isLoadingMore = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  bool _checkHasMoreData(AppBranches appBranches) {
    final meta = appBranches.meta;
    if (meta == null) return false;
    
    final currentPage = meta.currentPage ?? 1;
    final lastPage = meta.lastPage ?? 1;
    
    return currentPage < lastPage;
  }

  Widget _buildBody() {
    if (_isLoading && _branches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_branches.isEmpty && !_isLoading) {
      return const Center(
        child: Text(
          'no_branches_found'.tr(),
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _branches.clear();
          _currentPage = 1;
          _hasMoreData = true;
        });
        _loadInitialBranches();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _branches.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _branches.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final branch = _branches[index];
          return _buildBranchItem(branch);
        },
      ),
    );
  }

  Widget _buildBranchItem(Branch branch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Image
            if (branch.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  branch.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 12),
            
            // Branch Name
            if (branch.name != null)
              Text(
                branch.name!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            const SizedBox(height: 8),
            
            // Address Description
            if (branch.addressDescription != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      branch.addressDescription!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 8),
            
            // Region
            if (branch.region?.name != null)
              Row(
                children: [
                  const Icon(
                    Icons.map,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                                         'region_label'.tr().replaceAll('{}', branch.region!.name!),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            
            // Categories
            if (branch.categories?.isNotEmpty == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                                         'categories_label'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: branch.categories!
                        .map(
                          (category) => Chip(
                            label: Text(
                              category.name ?? '',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.blue[100],
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

*/