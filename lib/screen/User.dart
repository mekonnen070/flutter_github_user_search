import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_github_user_search/screen/Repos.dart';

class User extends StatefulWidget {
  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool loading = true;
  int itemIndex = 0;

  //const User({Key? key}) : super(key: key);
  TextEditingController textEditingController = TextEditingController();
  bool visible = false;
  String query = "";
  dynamic data;
  int currentPage = 0;
  int totalPages = 0;
  int sizePage = 20;
  List<dynamic> items = [];
  ScrollController scrollController = ScrollController();

  void _search(String t) {
    var url = Uri.parse(
        "https://api.github.com/search/users?q=$t&per_page=$sizePage&page=$currentPage");
    print(url);
    http.get(url).then((resp) {
      setState(() {
        data = jsonDecode(resp.body);
        items.addAll(data['items']);
        if (totalPages % sizePage == 0) {
          totalPages = data['total_count'] ~/ sizePage;
        } else {
          (totalPages = data['total_count'] / sizePage).floor() + 1;
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages - 1) {
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff141D2F),
      appBar: AppBar(
        backgroundColor: const Color(0xff141D2F),
        title: const Text('Github users finder'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icon-moon.svg',
            ),
          ),
        ],
      ),
// const Color(0xff1E2A47),

      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: TextFormField(
                          onChanged: (v) {
                            setState(() {
                              loading = false;
                              // _search(v);
                            });
                          },
                          // onFieldSubmitted: (v) {
                          //   _search(v);
                          // },
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          controller: textEditingController,
                          decoration: InputDecoration(
                              fillColor: const Color(0xff1E2A47),
                              filled: true,
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SvgPicture.asset(
                                  'assets/icon-search.svg',
                                ),
                              ),
                              suffix: ElevatedButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  primary: const Color(0xff0079ff),
                                  onSurface: Colors.white,
                                ),
                                onPressed: () {
                                  query = textEditingController.text;
                                  items = [];
                                  currentPage = 0;
                                  _search(query);
                                  setState(() {
                                    // textEditingController.clear();

                                    loading = false;
                                    // data = [];
                                  });
                                },
                                child: const Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.deepOrange),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      )),
                ),
              ],
            ),
            // data == null
            loading
                ? Repos(
                    login: data == null ? null : items[itemIndex]['login'],
                  )
                : Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                itemIndex = index;
                                loading = true;
                              });
                              setState(() {});
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(items[index]['avatar_url']),
                            ),
                            title: Text(
                              items[index]['login'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Text(
                              items[index]['score'].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
