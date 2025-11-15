class Apartment {
  final String id;
  final String name;
  final String location;
  final double price;
  final String description;
  final List<Map<String, String>>
  media; // each item: {'url': ..., 'type': 'image' or 'video'}
  final bool available;
  final List<Map<String, String>> features; // dynamic features

  Apartment({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.description,
    required this.media,
    required this.available,
    required this.features,
  });

  factory Apartment.fromFirestore(Map<String, dynamic> data, String docId) {
    // Media list
    List<Map<String, String>> mediaList = [];
    if (data['media'] != null && data['media'] is List) {
      mediaList = (data['media'] as List)
          .map(
            (m) => {
              'url': m['url']?.toString() ?? '',
              'type': m['type']?.toString() ?? 'image',
            },
          )
          .toList();
    } else {
      // fallback: use single mediaUrl if 'media' field doesn't exist
      mediaList = [
        {
          'url': data['mediaUrl']?.toString() ?? '',
          'type': data['mediaType']?.toString() ?? 'image',
        },
      ];
    }

    // Features list
    List<Map<String, String>> featuresList = [];
    if (data['features'] != null && data['features'] is List) {
      featuresList = (data['features'] as List)
          .map(
            (f) => {
              'icon': f['icon']?.toString() ?? 'star',
              'label': f['label']?.toString() ?? '',
            },
          )
          .toList();
    }

    return Apartment(
      id: docId,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      media: mediaList,
      available: data['available'] ?? true,
      features: featuresList,
    );
  }

  // 👇 Helper getters to make UI cleaner
  String get mediaUrl => media.isNotEmpty ? media[0]['url'] ?? '' : '';

  String get mediaType =>
      media.isNotEmpty ? media[0]['type'] ?? 'image' : 'image';
}
