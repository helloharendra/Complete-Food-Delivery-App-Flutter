class CakeItemsModel {
  final String cakeImageLink;
  final String? cakeDiscount;
  final String name;
  final String cakeRating;

  CakeItemsModel(
      {required this.cakeImageLink,
      this.cakeDiscount,
      required this.name,
      required this.cakeRating});
}
