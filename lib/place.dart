class Place {
  String id;
  String name;
  String state;
  String category;
  String description;
  String imageUrl;
  double latitude;
  double longitude;
  String contact;
  double rating;

  Place({
    required this.id,
    required this.name,
    required this.state,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.contact,
    required this.rating,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return Place(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      contact: (json['contact'] ?? '').toString(),
      rating: toDouble(json['rating']),
    );
  }
}
