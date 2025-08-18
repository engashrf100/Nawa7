import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class AppBranch {
  Branch? data;
  int? status;

  AppBranch({this.data, this.status});

  AppBranch.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Branch.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}
