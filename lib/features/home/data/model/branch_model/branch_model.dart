class Branch {
  int? id;
  String? name;
  String? addressDescription;
  String? image;
  String? createdAt;
  String? updatedAt;

  Region? region;
  List<Category>? categories;

  List<String>? phones;
  List<String>? whatsappNumbers;

  WorkDays? workDays;
  List<String>? gallery;

  String? facebook;
  String? x;
  String? youtube;
  String? instagram;
  String? tiktok;
  String? snapchat;

  Branch({
    this.id,
    this.name,
    this.addressDescription,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.region,
    this.categories,
    this.phones,
    this.whatsappNumbers,
    this.workDays,
    this.gallery,
    this.facebook,
    this.x,
    this.youtube,
    this.instagram,
    this.tiktok,
    this.snapchat,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      addressDescription: json['address_description'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      categories: json['categories'] != null
          ? List<Category>.from(
              json['categories'].map((x) => Category.fromJson(x)),
            )
          : [],
      phones: json['phones'] != null ? List<String>.from(json['phones']) : [],
      whatsappNumbers: json['whatsapp_numbers'] != null
          ? List<String>.from(json['whatsapp_numbers'])
          : [],
      workDays: json['work_days'] != null
          ? WorkDays.fromJson(json['work_days'])
          : null,
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'])
          : [],
      facebook: json['facebook'],
      x: json['x'],
      youtube: json['youtube'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      snapchat: json['snapchat'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address_description': addressDescription,
    'image': image,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'region': region?.toJson(),
    'categories': categories?.map((x) => x.toJson()).toList(),
    'phones': phones,
    'whatsapp_numbers': whatsappNumbers,
    'work_days': workDays?.toJson(),
    'gallery': gallery,
    'facebook': facebook,
    'x': x,
    'youtube': youtube,
    'instagram': instagram,
    'tiktok': tiktok,
    'snapchat': snapchat,
  };
}

class Region {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  String? activeClass;
  String? activeStatus;

  Region({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.activeClass,
    this.activeStatus,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json['id'],
    name: json['name'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    isActive: json['is_active'],
    activeClass: json['active_class'],
    activeStatus: json['active_status'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_active': isActive,
    'active_class': activeClass,
    'active_status': activeStatus,
  };
}


class Category {
  int? id;
  String? name;
  String? logo;

  Category({this.id, this.name, this.logo});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'], name: json['name'], logo: json['logo']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'logo': logo};
}


class WorkDays {
  bool? sunday;
  bool? monday;
  bool? tuesday;
  bool? wednesday;
  bool? thursday;
  bool? friday;
  bool? saturday;

  WorkDays({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory WorkDays.fromJson(Map<String, dynamic> json) => WorkDays(
    sunday: json['sunday'],
    monday: json['monday'],
    tuesday: json['tuesday'],
    wednesday: json['wednesday'],
    thursday: json['thursday'],
    friday: json['friday'],
    saturday: json['saturday'],
  );

  Map<String, dynamic> toJson() => {
    'sunday': sunday,
    'monday': monday,
    'tuesday': tuesday,
    'wednesday': wednesday,
    'thursday': thursday,
    'friday': friday,
    'saturday': saturday,
  };
}
