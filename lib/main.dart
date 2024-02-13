import 'dart:convert' show json;

import 'package:candlesticks_tab/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Candlesticks Chart Guide'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "Sachin";
  int currentPageIndex = 0;
  InterstitialAd? _interstitialAd;
  final adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }
  void _incrementCounter() {
    setState(() {
      _changeName();
    });
  }

  void _changeName() {
    setState(() {
      name = "Sachin Kanojia";
    });
  }
  void loadAd() {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            _interstitialAd?.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  // Future<List<HomeData>> postsFuture = getPosts("url");

  // function to fetch data from api and return future list of posts
  static Future<List<HomeData>> getPosts(String url) async {
    var urlPost = Uri.parse(url);
    final response = await http.get(urlPost, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => HomeData.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(widget.title, style: TextStyle(color: Colors.white),),
        ),

      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: "Guide",
          ),
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: "IPO",
          ),
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: "Bonus",
          ),
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: "Dividend",
          ),
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: "Results",
          ),
        ],
      ),
      body: <Widget>[
        Center(
          child: _homeTab("https://candlestickschart.com/api/webservice.php?service=appversion"),
        ),
        Center(
          child: _homeTab("https://candlestickschart.com/api/webservice.php?service=ipo"),
        ),
        Center(
          child: _homeTab("https://candlestickschart.com/api/webservice.php?service=bonus"),
        ),
        Center(
          child: _homeTab("https://candlestickschart.com/api/webservice.php?service=dividend"),
        ),
        Center(
          child: _homeTab("https://candlestickschart.com/api/webservice.php?service=analysis"),
        ),
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _homeTab(String url) {
    return Container(
      child: FutureBuilder<List<HomeData>>(
        future: getPosts(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // until data is fetched, show loader
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // once data is fetched, display it on screen (call buildPosts())
            final posts = snapshot.data!;
            return buildPosts(posts);
          } else {
            // if no data, show simple Text
            return const Text("No data available");
          }
        },
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<HomeData> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: double.maxFinite,
            child: SizedBox(
              child: ListTile(
                title: Text(post.title!),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(id: index, title: post.title, content: post.content,postData: posts,)));
                },
                leading: const Icon(Icons.candlestick_chart),
              ),
            )
        );
      },
    );
  }
}