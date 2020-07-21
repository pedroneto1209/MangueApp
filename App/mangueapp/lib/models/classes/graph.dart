class Graph {
  String userId;
  String data;
  String typedata;
  String date;
  int id;
  
  Graph(this.userId, this.data, this.typedata, this.date, this.id);

  factory Graph.fromJson(Map<String, dynamic> parsedJson) {
    return Graph(
      parsedJson['userId'],
      parsedJson['data'],
      parsedJson['typedata'],
      parsedJson['date'],
      parsedJson['id'],
      );
  }
}