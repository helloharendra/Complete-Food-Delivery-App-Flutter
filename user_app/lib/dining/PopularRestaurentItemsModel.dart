class PopularRestaurentItemsModel {
  final String restaurentImage;
  final String restaurentName;
  final String restaurentRating;
  final String? restaurentItemCategory;
  final String? restaurentItemPrice;
  final String? restaurentAddress;
  final String? restaurentDistance;

  PopularRestaurentItemsModel(
      {required this.restaurentImage,
      required this.restaurentName,
      required this.restaurentRating,
      this.restaurentItemCategory,
      this.restaurentItemPrice,
      this.restaurentAddress,
      this.restaurentDistance});
}
