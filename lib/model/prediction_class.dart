class PredictionClass {
  double confidence;
  String label;

  PredictionClass.fromJson(var data) {
    this.confidence = data['confidence'];
    this.label = data['label'];
  }
}
