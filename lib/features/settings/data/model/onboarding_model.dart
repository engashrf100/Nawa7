class OnboardingModel {
  List<OnboardingPage>? pages;
  int? status;

  OnboardingModel({this.pages, this.status});

  OnboardingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      pages = <OnboardingPage>[];
      json['data'].forEach((v) {
        pages!.add(OnboardingPage.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (pages != null) {
      data['data'] = pages!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class OnboardingPage {
  int? id;
  String? name;
  String? description;
  String? image;

  OnboardingPage({this.id, this.name, this.image, this.description});

  OnboardingPage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];

    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;

    data['image'] = image;
    return data;
  }
}
