import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    initTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[800],
        appBar: AppBar(
          title: Text(
            "Up-N-Down Score",
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Column(
            children: [
              Container(padding: const EdgeInsets.all(20.0), child: Text("Up-N-Down Score", style: Theme.of(context).textTheme.headline2)),
            ],
          ),
          // Image(
          //   image: (AssetImage("content/images/logo.png")),
          // )

          // child: const CircularProgressIndicator()
        ));
  }

  Future<void> initTasks() async {
    String navigateTo = '/home';

    Future.delayed(Duration.zero, () async {
      await Navigator.of(context).pushReplacementNamed(navigateTo);
    });
  }
}
