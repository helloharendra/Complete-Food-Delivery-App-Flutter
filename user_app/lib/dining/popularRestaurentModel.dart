class PopularRestaurentModel {
  final String restaurentName;
  final String? restaurentRating;
  final String? restaurentItemCategory;
  final String? restaurentItemPrice;
  final String? restaurentAdderess;
  final String? restaurentDistance;
  final String? restaurentImage;

  PopularRestaurentModel({
    required this.restaurentName,
    this.restaurentRating,
    this.restaurentItemCategory,
    this.restaurentItemPrice,
    this.restaurentAdderess,
    this.restaurentDistance,
    this.restaurentImage,
  });
}
