import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class AppBranches {
  final List<Branch>? branches;
  final PaginationLinks? paginationLinks;
  final Meta? meta;
  final int? status;

  AppBranches({this.branches, this.paginationLinks, this.meta, this.status});

  factory AppBranches.fromJson(Map<String, dynamic> json) {
    return AppBranches(
      branches: (json['data'] as List?)
          ?.map((e) => Branch.fromJson(e))
          .toList(),
      paginationLinks: json['links'] != null
          ? PaginationLinks.fromJson(json['links'])
          : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': branches?.map((e) => e.toJson()).toList(),
    'links': paginationLinks?.toJson(),
    'meta': meta?.toJson(),
    'status': status,
  };
}

class PaginationLinks {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      PaginationLinks(
        first: json['first'],
        last: json['last'],
        prev: json['prev'],
        next: json['next'],
      );

  Map<String, dynamic> toJson() => {
    'first': first,
    'last': last,
    'prev': prev,
    'next': next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json['current_page'],
    from: json['from'],
    lastPage: json['last_page'],
    links: (json['links'] as List?)?.map((e) => MetaLink.fromJson(e)).toList(),
    path: json['path'],
    perPage: json['per_page'],
    to: json['to'],
    total: json['total'],
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'links': links?.map((e) => e.toJson()).toList(),
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

class MetaLink {
  final String? url;
  final String? label;
  final bool? active;

  MetaLink({this.url, this.label, this.active});

  factory MetaLink.fromJson(Map<String, dynamic> json) =>
      MetaLink(url: json['url'], label: json['label'], active: json['active']);

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}
