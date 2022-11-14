import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/providers/post_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final postProvider = PostProvider();
  List<PostModel> posts = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: GoogleFonts.lobsterTwo(
            textStyle: const TextStyle(fontSize: 28, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.black,
              )),
        ],
      ),
      body: StreamBuilder(
          stream: postProvider.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return const Center(child: Text('Empty Data'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    PostModel post =
                        PostModel.fromSnap(snapshot.data!.docs[index]);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(post.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListTile(
                                  leading: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data!
                                              .data()!['profileImage'],
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(snapshot.data!.data()!['name']),
                                  subtitle:
                                      Text(snapshot.data!.data()!['username']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {},
                                  ),
                                );
                              }
                              return const CircularProgressIndicator();
                            }),
                        CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            imageUrl: post.postUrl),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_outline,
                                  size: 30,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 30,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.send_outlined,
                                  size: 30,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            '${post.likes.length} likes',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(post.postUrl),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                'Add a comment...',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                );
              }
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }),
    );
  }
}
