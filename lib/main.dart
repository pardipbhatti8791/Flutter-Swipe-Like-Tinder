import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/Post.dart';

void main() {
  runApp(new MaterialApp(
    title: "Hello Gugu",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }

}

class HomeState extends State<Home> {

  final posts = List<Post>();
  var _isLoading = true;

  _fetchPosts() async {
    final response = await http.get("https://jsonplaceholder.typicode.com/posts");
    if (response.statusCode == 200) {
      final postsJson = json.decode(response.body);
      postsJson.forEach((singlePost) {
        final post = new Post(singlePost["id"], singlePost["title"], singlePost["body"]);
        posts.add(post);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Color getColor(double id) {
    return Color.lerp(Colors.red, Colors.green, id/10);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("hello")
      ),
      body: new Center(
        child: _isLoading == true ? new CircularProgressIndicator() :
        new ListView.builder(itemCount: posts.length,itemBuilder: (context, i) {
          final singlPost = posts[i];
          return new Dismissible(
            key: new Key(singlPost.title),
            background: new Container(color: Colors.greenAccent,),
            secondaryBackground: new Container(color: Colors.redAccent,),
            onDismissed: (direction) {
              direction == DismissDirection.endToStart ?
              Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("I hate it"), backgroundColor: Colors.redAccent)) :
              Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("I like it"), backgroundColor: Colors.green,));
            },
            child: new ListTile(
              leading: new CircleAvatar(
                child: new Text("${singlPost.id}"),
                backgroundColor: getColor(singlPost.id.toDouble()),
              ),
              title: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(singlPost.title),
              ),
              subtitle: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(singlPost.body),
              ),
            ),
          );
        }),
      ),
    );
  }
}