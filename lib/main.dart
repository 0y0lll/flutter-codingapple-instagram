import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_codingapple_instagram/style/style.dart' as style;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Store(),
    child: MaterialApp(theme: style.themeData, initialRoute: '/', routes: {
      '/': (context) => MyApp(),
      // '/upload': (context) => Upload(),
    }),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var currentIndex = 0;
  var feeds = [];
  var userImage;
  var userContent;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    scrollController.addListener(() {
      // 스크롤 할 때 마다 실행
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('Instagram',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                  color: Colors.black)),
          actions: [
            IconButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  var image =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() {
                      userImage = File(image.path);
                    });
                  }

                  // Navigator.pushNamed(context, '/upload');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Upload(
                              userImage: userImage,
                              setUserContent: setUserContent)));
                },
                icon: Icon(Icons.add_box_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: Icon(Icons.person_2_outlined)),
          ],
        ),
        body: [
          ListView.builder(
              itemCount: feeds.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return feedItem(context, feeds[index]);
              }),
          TextButton(
              onPressed: () {},
              child: Text(
                'Text Button',
                style: TextStyle(color: Colors.white),
              ))
        ][currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: '꼭 라벨이'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: '필요하나'),
            ]));
  }

  Widget feedItem(BuildContext context, item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            child: Image.network(
              item['image'],
              fit: BoxFit.cover,
            )),
        Row(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.thumb_up_alt_outlined)),
              Text(item['likes'].toString()),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.mode_comment_outlined)),
              Text('0'),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
              Text('0'),
            ],
          ),
        ]),
        Padding(
            padding: EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                item['user'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(item['content'])
            ]))
      ],
    );
  }

  Future getData() async {
    var response = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body).map((item) => item).toList();

      setState(() {
        feeds = result;
      });
    } else {
      setState(() {
        feeds = [];
      });
    }
  }

  Future getMoreData() async {
    var response = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addFeed(result);
    }
  }

  void addFeed(Map<dynamic, dynamic> data) {
    setState(() {
      feeds.add(data);
    });
  }

  void setUserContent(String content) {
    setState(() {
      userContent = content;
    });
  }

  void addUserFeed() {
    var data = {
      'id': feeds.last['id'] + 1,
      'image': userImage,
      'likes': 10,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'leona'
    };

    setState(() {
      feeds.insert(0, data);
    });
  }

  void saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = [
      jsonEncode({'age': 20})
    ];

    storage.setStringList('content', map);
  }
}

class Upload extends StatelessWidget {
  Upload({Key? key, this.userImage, this.setUserContent}) : super(key: key);
  final userImage;
  final setUserContent;
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: Image.file(
                  userImage,
                  fit: BoxFit.cover,
                )),
            Text('이미지업로드화면'),
            TextField(
                controller: textController,
                onChanged: (value) {
                  setUserContent(value);
                }),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
            TextButton(onPressed: () {}, child: Text('post'))
          ],
        ));
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<Store>().name,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                  color: Colors.black)),
        ),
        body: Column(
          children: [
            Text('Profile'),
            TextButton(
              onPressed: () {
                context.read<Store>().changeName();
              },
              child: Text('이름 변경',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            Text(context.watch<Store>().follower.toString()),
            TextButton(
              onPressed: () {
                // TODO:
              },
              child: Text('팔로우',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ));
  }
}

class Store extends ChangeNotifier {
  var name = 'leona';
  var follower = 0;

  void changeName() {
    name = 'Leona';
    notifyListeners();
  }
}
