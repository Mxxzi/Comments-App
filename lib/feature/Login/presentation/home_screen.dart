import 'dart:convert';
import 'dart:developer';
import 'package:comments_app/Authentication/backend_apis.dart';
import 'package:comments_app/feature/Login/presentation/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Post postsFuture;
  late Future<void> _fetchRemoteConfig;
  bool _maskEmail = false;

  @override
  void initState() {
    super.initState();
    // postsFuture = getPosts();
    // log('postsFuture $postsFuture');
    // _fetchRemoteConfig = _initializeRemoteConfig();
    testRemote();
  }

  Future<void> _initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.fetchAndActivate();
      setState(() {
        _maskEmail = remoteConfig.getBool('mask_email');
      });
      print('Remote Config - mask_email: $_maskEmail'); // Debug logging
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  String _maskEmailAddress(String email) {
    String emailPrefix = email.substring(0, 3);
    String emailSuffix = email.split('@')[1];
    return '$emailPrefix****@$emailSuffix';
  }

  testRemote() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    final config = json.decode(
      remoteConfig.getString('comments'),
    ) as Map<String, dynamic>;
    _maskEmail = config['showEmail'];

    log('remoteValue $config');
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

          final commentsData = jsonDecode(snapshot.data!);

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final comment = commentsData[index];
              final email = comment['email'];
              final displayEmail = _maskEmailAddress(email);

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
                        _maskEmail
                            ? Text('Email: $displayEmail')
                            : Text('Email: ${commentsData[index]['email']}'),
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
