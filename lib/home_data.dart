
class HomeData {
  int? id;
  String? title;
  String? imageUrl;
  String? content;
  String? url;
  HomeData(this.id, this.title, this.imageUrl, this.content, this.url);
  HomeData.fromJson(Map <String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    imageUrl = json['Image'];
    content = json['Content'];
    url = json['Url'];
  }
}