class RecipeModel {
  String? label;
  String? image;
  String? url;
  String? source;
  List<String>? dietLabels;

  RecipeModel({
    required this.label,
    required this.image,
    required this.url,
    required this.source,
    this.dietLabels,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    final List<dynamic>? dietLabelsList = parsedJson["dietLabels"];
    final List<String>? dietLabels =
    dietLabelsList?.map((label) => label.toString()).toList();

    return RecipeModel(
      label: parsedJson["label"],
      image: parsedJson["image"],
      url: parsedJson["url"],
      source: parsedJson["source"],
      dietLabels: dietLabels,
    );
  }
}
