import 'package:flutter/material.dart';
import 'package:up_n_down_score/models/new_game.dart';

class NewGameDialog extends StatefulWidget {
  final Function(List<String>) onSubmit;
  const NewGameDialog({required this.onSubmit, super.key});

  @override
  _widgetState createState() => _widgetState();
}

class _widgetState extends State<NewGameDialog> {
  TextEditingController _playerController1 = TextEditingController();
  TextEditingController _playerController2 = TextEditingController();
  TextEditingController _playerController3 = TextEditingController();
  TextEditingController _playerController4 = TextEditingController();
  TextEditingController _playerController5 = TextEditingController();
  TextEditingController _playerController6 = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                    getTextBox("Player 1", _playerController1, autofocus: true),
                    getTextBox("Player 2", _playerController2),
                    getTextBox("Player 3", _playerController3),
                    getTextBox("Player 4", _playerController4),
                    getTextBox("Player 5", _playerController5),
                    getTextBox("Player 6", _playerController6),
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
                            if (_playerController1.text.isNotEmpty) {
                              players.add(_playerController1.text);
                            }
                            if (_playerController2.text.isNotEmpty) {
                              players.add(_playerController2.text);
                            }
                            if (_playerController3.text.isNotEmpty) {
                              players.add(_playerController3.text);
                            }
                            if (_playerController4.text.isNotEmpty) {
                              players.add(_playerController4.text);
                            }
                            if (_playerController5.text.isNotEmpty) {
                              players.add(_playerController5.text);
                            }
                            if (_playerController6.text.isNotEmpty) {
                              players.add(_playerController6.text);
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
