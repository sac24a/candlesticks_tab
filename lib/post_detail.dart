import 'package:candlesticks_tab/home_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
//ignore: must_be_immutable
class Detail extends StatelessWidget {
  Detail({super.key, required this.id, required this.title, required this.content, required this.postData});
  int? id;
  String? title;
  String? content;
  List<HomeData> postData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Learn", style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Share clicked");
          Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.share,
          color: Colors.white,
        ),
      ),
      body: PageViewInfiniteExample(id: id, title: title, content: content, postData: postData,),
    );
  }
}
//ignore: must_be_immutable
class ListViewExample extends StatelessWidget {
  ListViewExample({super.key, required this.id, required this.title, required this.content});
  int? id;
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child:Text(title ?? "Hello",
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(double.maxFinite, 300),
              child: const Icon(
                Icons.candlestick_chart,
              ),
            ),
            const SizedBox(
              width: double.maxFinite,
              height: 20,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Html(data:content),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: shareBar(),
            ),
          ],
        ),
      ],
    );
  }
}

class PageViewExample extends StatelessWidget {
  const PageViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: <Widget>[
        Center(
          child: ListViewExample(id: 1, title: "title", content: "content",),
        ),
        Center(
          child: ListViewExample(id: 1, title: "title", content: "content",),
        ),
        Center(
          child: ListViewExample(id: 1, title: "title", content: "content",),
        ),
      ],
    );
  }
}
//ignore: must_be_immutable
class PageViewInfiniteExample extends StatelessWidget {
  PageViewInfiniteExample({super.key, required this.id, required this.title, required this.content, required this.postData});
  int? id;
  String? title;
  String? content;
  List<HomeData> postData;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return PageView.builder(itemBuilder: (context, int currentIndex) {
      if (index == 0) {
        index = id!;
      } else {
        index++;
      }
      return ListViewExample(
        id: postData[index % postData.length].id,
        title: postData[index % postData.length].title,
        content: postData[index % postData.length].content,
      );
    });
  }
}

Widget shareBar() {
  return Container(
    color: Colors.black,
    height: 50,
    child: const Row(
      children: [
        Expanded(
            child: Icon(
              Icons.share,
              color: Colors.white,
            )),
        Expanded(child: Icon(Icons.whatshot, color: Colors.white)),
        Expanded(child: Icon(Icons.bluetooth, color: Colors.white)),
        Expanded(child: Icon(Icons.call, color: Colors.white)),
      ],
    ),
  );
}
