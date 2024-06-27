import 'dart:convert';
import 'dart:developer';
import 'package:comments_app/Authentication/backend_apis.dart';
import 'package:comments_app/feature/Login/presentation/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:comments_app/Model/post_model.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Post postsFuture;

  @override
  void initState() {
    super.initState();
    // postsFuture = getPosts();
    // log('postsFuture $postsFuture');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: false,
        backgroundColor: const Color(0xff0C54BE),
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: BackendApis().getComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final commentsData = jsonDecode(snapshot.data!);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xffCED3DC),
                      child: Text(commentsData![index]['name']
                          .toString()
                          .split('')
                          .first
                          .toUpperCase()),
                    ),
                    title: Text('Name: ${commentsData![index]['name']!}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${commentsData[index]['email']}'),
                        Text(commentsData[index]['email']),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (ctx) => const LoginScreen()));
        },
        child: const Icon(Icons.logout_outlined),
      ),
    );
  }
}
