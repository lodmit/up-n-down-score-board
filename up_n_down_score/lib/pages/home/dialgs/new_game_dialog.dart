import 'package:flutter/material.dart';
import 'package:up_n_down_score/models/new_game.dart';

class NewGameDialog extends StatefulWidget {
  final Function(List<String>) onSubmit;
  final List<String>? players;
  const NewGameDialog({required this.onSubmit, super.key, this.players});

  @override
  _widgetState createState() => _widgetState();
}

class _widgetState extends State<NewGameDialog> {
  List<TextEditingController> playerControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();

    int index = 0;
    if (widget.players != null) {
      for (var p in widget.players!) {
        if (index < 6) {
          playerControllers[index].text = p;
        } else {
          break;
        }
        index++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.grey[200],
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    getTextBox("Player 1", playerControllers[0], autofocus: true),
                    getTextBox("Player 2", playerControllers[1]),
                    getTextBox("Player 3", playerControllers[2]),
                    getTextBox("Player 4", playerControllers[3]),
                    getTextBox("Player 5", playerControllers[4]),
                    getTextBox("Player 6", playerControllers[5]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: TextButton(
                          child: const Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: ElevatedButton(
                          child: const Text("Play"),
                          onPressed: () {
                            List<String> players = [];

                            for (var pc in playerControllers) {
                              if (pc.text.isNotEmpty) {
                                players.add(pc.text);
                              }
                            }

                            widget.onSubmit(players);

                            Navigator.pop(context);
                          })),
                ],
              )
            ],
          ),
        ));
  }

  Widget getTextBox(String label, TextEditingController controller, {bool autofocus = false}) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        //focusNode: _searchFocusNode,
        autofocus: autofocus,
        // style: TextStyle(fontWeight: FontWeight.bold ),
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          labelText: label,
          //labelStyle: TextStyle(fontSize: 15, fontFamily: "RobotoCondensed", color: Colors.black45),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
          //hintText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          suffixIcon: InkWell(
            child: Icon(Icons.cancel, color: Colors.black54, size: 14),
            onTap: () {
              setState(() {
                controller.clear();
              });
            },
          ),
        ),
      ),
    );
  }
}
