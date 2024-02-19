import 'package:da_order/common/const/data.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount, deliveryTime, deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    required this.priceRange,
  });

  factory RestaurantModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$ip${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      ratings: json['ratings'],
      priceRange: RestaurantPriceRange.values.firstWhere(
        (element) => element.name == json['priceRange'],
      ),
    );
  }
}
