// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Repos extends StatefulWidget {
  static const id = 'repos';

  String? login;

  Repos({
    Key? key,
    this.login,
  }) : super(key: key);

  @override
  State<Repos> createState() => _ReposState();
}

class _ReposState extends State<Repos> {
  bool isLoading = true;
  dynamic data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRepos();
  }

  void loadRepos() async {
    Uri url = Uri.parse("https://api.github.com/users/${widget.login!}");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        isLoading = false;
      });
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Card(
          color: const Color(0xff1E2A47),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 0),
                  child: data == null
                      ? CircleAvatar(
                          child: SvgPicture.asset('assets/octocat.svg'))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(data!['avatar_url']!),
                          // radius: 50,
                        ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data == null ? 'The Octocat' : data!['name']!,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data == null
                                  ? 'Joined 25 Jan 2020'
                                  : data!['created_at'].substring(
                                      0,
                                      data!['created_at'].indexOf(':'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        data == null ? '@Octocat' : data!['login'],
                        style: const TextStyle(color: Color(0xff0079ff)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      data != null
                          ? data!['bio'] == null
                              ? const Text('There is no bio available.')
                              : Text(data!['bio'])
                          : const Text('Bio'),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: const Color(0xff141D2F),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Repos'),
                                  Text(data == null
                                      ? '8'
                                      : data!['public_repos'].toString()),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Follower'),
                                  Text(data == null
                                      ? '3938'
                                      : data!['followers'].toString()),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Following'),
                                  Text(data == null
                                      ? '9'
                                      : data!['following'].toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 5),
                              data != null
                                  ? Text(
                                      data!['location'] == null
                                          ? 'San Francisco'
                                          : data!['location'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text('San Francisco'),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icon-twitter.svg',
                              ),
                              const SizedBox(width: 5),
                              data != null
                                  ? data!['twitter_username'] == null
                                      ? const Text('Not available')
                                      : Text(
                                          data!['twitter_username'],
                                          overflow: TextOverflow.ellipsis,
                                        )
                                  : const Text('Not available')
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icon-website.svg',
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    data == null
                                        ? 'https://github.blog'
                                        : data!['html_url'].toString(),
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     SvgPicture.asset(
                              //       'assets/icon-twitter.svg',
                              //     ),
                              //     const SizedBox(width: 5),
                              //     data!['twitter_username'] == null
                              //         ? const Text('Not available')
                              //         : Text(data!['twitter_username'])
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    //  Center(
    //     child: ListView.separated(
    //         itemBuilder: (context, index) => ListTile(
    //               title: Text(data![index]['name']),
    //             ),
    //         separatorBuilder: (context, index) => const Divider(
    //               height: 2,
    //               color: Colors.blue,
    //             ),
    //         itemCount: data == null ? 0 : data.length)),
  }
}
