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
  WorkTimes? workTimes;
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
    this.workTimes,
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
      workDays: json['work_days'] != null && json['work_days'] is Map<String, dynamic>
          ? WorkDays.fromJson(json['work_days'])
          : null,
      workTimes: json['work_times'] != null && json['work_times'] is Map<String, dynamic>
          ? WorkTimes.fromJson(json['work_times'])
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
    'work_times': workTimes?.toJson(),
    'gallery': gallery,
    'facebook': facebook,
    'x': x,
    'youtube': youtube,
    'instagram': instagram,
    'tiktok': tiktok,
    'snapchat': snapchat,
  };
}

// New wrapper class for API response
class BranchResponse {
  final Branch? data;
  final int? status;

  BranchResponse({this.data, this.status});

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    return BranchResponse(
      data: json['data'] != null ? Branch.fromJson(json['data']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
    'status': status,
  };
}

// New class for individual time slots
class WorkTime {
  final String? fromTime;
  final String? toTime;
  final String? timeRange;

  WorkTime({
    this.fromTime,
    this.toTime,
    this.timeRange,
  });

  factory WorkTime.fromJson(Map<String, dynamic> json) {
    return WorkTime(
      fromTime: json['from_time'],
      toTime: json['to_time'],
      timeRange: json['time_range'],
    );
  }

  Map<String, dynamic> toJson() => {
    'from_time': fromTime,
    'to_time': toTime,
    'time_range': timeRange,
  };
}

// New class for working times for all days
class WorkTimes {
  final List<WorkTime>? sunday;
  final List<WorkTime>? monday;
  final List<WorkTime>? tuesday;
  final List<WorkTime>? wednesday;
  final List<WorkTime>? thursday;
  final List<WorkTime>? friday;
  final List<WorkTime>? saturday;

  WorkTimes({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory WorkTimes.fromJson(Map<String, dynamic> json) {
    return WorkTimes(
      sunday: json['sunday'] != null
          ? List<WorkTime>.from(
              json['sunday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      monday: json['monday'] != null
          ? List<WorkTime>.from(
              json['monday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      tuesday: json['tuesday'] != null
          ? List<WorkTime>.from(
              json['tuesday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      wednesday: json['wednesday'] != null
          ? List<WorkTime>.from(
              json['wednesday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      thursday: json['thursday'] != null
          ? List<WorkTime>.from(
              json['thursday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      friday: json['friday'] != null
          ? List<WorkTime>.from(
              json['friday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
      saturday: json['saturday'] != null
          ? List<WorkTime>.from(
              json['saturday'].map((x) => WorkTime.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'sunday': sunday?.map((x) => x.toJson()).toList(),
    'monday': monday?.map((x) => x.toJson()).toList(),
    'tuesday': tuesday?.map((x) => x.toJson()).toList(),
    'wednesday': wednesday?.map((x) => x.toJson()).toList(),
    'thursday': thursday?.map((x) => x.toJson()).toList(),
    'friday': friday?.map((x) => x.toJson()).toList(),
    'saturday': saturday?.map((x) => x.toJson()).toList(),
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
