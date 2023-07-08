class DiningHomeModel {
  final String? restaurentImage;
  final String? restaurentDiscount;
  final String restaurentName;
  final String distance;
  final String rating;
  final String imageLInk;

  DiningHomeModel(
      {this.restaurentImage,
      this.restaurentDiscount,
      required this.restaurentName,
      required this.distance,
      required this.rating,
      required this.imageLInk});
}
