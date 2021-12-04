import 'package:east_telecom_project/ui/map/map_screen.dart';
import 'package:east_telecom_project/ui/push/push_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("East telecom tasks"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Task 1 : "),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const MapScreen(),
                  ),
                );
              },
              child: const Text("Open Google Map"),
            ),
            const Divider(
              height: 10,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Task 2 : "),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const PushScreen(),
                  ),
                );
              },
              child: const Text("Open Push Manager"),
            )
          ],
        ),
      ),
    );
  }
}
