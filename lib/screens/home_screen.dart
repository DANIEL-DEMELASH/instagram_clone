import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userProvider = UserProvider();
  @override
  void initState() {
    super.initState();
    userProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => userProvider,
      child: Consumer(
        builder: (context, UserProvider user, child) {
          switch (user.status) {
            case Status.intial:
              return const Scaffold(body: CircularProgressIndicator.adaptive());

            case Status.loading:
              return const Scaffold(body: CircularProgressIndicator.adaptive());

            case Status.done:
              return Center(child: Text(user.getUser.name));

            case Status.error:
              return const Center(
                child: Text('an error occured'),
              );

            default:
              return const Text('default');
          }
        },
      ),
    );
  }
}
