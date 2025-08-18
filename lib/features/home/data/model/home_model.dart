import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class HomeModel {
  List<Sliders>? sliders;
  List<Contracts>? contracts;
  List<Benefit>? benefit;
  List<ClientReview>? clientReviews;
  List<Branch>? HomeBranches;

  HomeModel({
    this.sliders,
    this.contracts,
    this.benefit,
    this.clientReviews,
    this.HomeBranches,
  });

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(Sliders.fromJson(v));
      });
    }
    if (json['contracts'] != null) {
      contracts = <Contracts>[];
      json['contracts'].forEach((v) {
        contracts!.add(Contracts.fromJson(v));
      });
    }
    if (json['benefit'] != null) {
      benefit = <Benefit>[];
      json['benefit'].forEach((v) {
        benefit!.add(Benefit.fromJson(v));
      });
    }
    if (json['client_reviews'] != null) {
      clientReviews = <ClientReview>[];
      json['client_reviews'].forEach((v) {
        clientReviews!.add(ClientReview.fromJson(v));
      });
    }
    if (json['branches'] != null) {
      HomeBranches = <Branch>[];
      json['branches'].forEach((v) {
        HomeBranches!.add(Branch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sliders != null) {
      data['sliders'] = sliders!.map((v) => v.toJson()).toList();
    }
    if (contracts != null) {
      data['contracts'] = contracts!.map((v) => v.toJson()).toList();
    }
    if (benefit != null) {
      data['benefit'] = benefit!.map((v) => v.toJson()).toList();
    }
    if (clientReviews != null) {
      data['client_reviews'] = clientReviews!.map((v) => v.toJson()).toList();
    }
    if (HomeBranches != null) {
      data['branches'] = HomeBranches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  int? id;
  String? image;

  Sliders({this.id, this.image});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'image': image};
}

class Contracts {
  int? id;
  String? name;
  String? image;

  Contracts({this.id, this.name, this.image});

  Contracts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}

class Benefit {
  int? id;
  String? name;
  String? description;
  String? image;

  Benefit({this.id, this.name, this.description, this.image});

  Benefit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
  };
}

/// ✅ الجديد
class ClientReview {
  int? id;
  String? name;
  String? description;
  String? clientJob;
  String? clientName;
  int? stars;
  String? image;
  String? createdAt;
  String? updatedAt;

  ClientReview({
    this.id,
    this.name,
    this.description,
    this.clientJob,
    this.clientName,
    this.stars,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  ClientReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    clientJob = json['client_job'];
    clientName = json['client_name'];
    stars = json['stars'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'client_job': clientJob,
    'client_name': clientName,
    'stars': stars,
    'image': image,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
