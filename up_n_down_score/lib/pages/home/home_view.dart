import 'package:flutter/material.dart';
import 'package:up_n_down_score/models/new_game.dart';
import 'package:up_n_down_score/pages/home/dialgs/new_game_dialog.dart';
import '../../core/page_arguments.dart';
import '../../shared/base_view.dart';
import 'home_model.dart';
import 'package:data_table_2/data_table_2.dart';

class HomeView extends StatefulWidget {
  final PageArguments? arguments;

  const HomeView({this.arguments, Key? key}) : super(key: key);

  @override
  _StatefulWidget createState() => _StatefulWidget();
}

class _StatefulWidget extends State<HomeView> with SingleTickerProviderStateMixin {
  PageArguments? arguments;

  late HomeModel model;

  final ScrollController _scrollController1 = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    arguments = widget.arguments;

    return BaseView<HomeModel>(
        onModelReady: (model) async {
          this.model = model;

          Future.delayed(Duration(seconds: 2), () async {
            if (model.game == null) {
              newGameDialog();
            }
          });
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Row(
                  children: const [
                    Expanded(
                      child: Text("Up-n-Down Score Board"),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          model.fontSize++;
                        });
                      },
                      icon: Icon(Icons.arrow_circle_up_rounded)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (model.fontSize > 10) model.fontSize--;
                        });
                      },
                      icon: Icon(Icons.arrow_circle_down_rounded)),
                  SizedBox(width: 20),
                  SizedBox(
                      width: 100,
                      // height: 30,
                      child: ElevatedButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                          onPressed: () => newGameDialog(),
                          child: const Text("New Game"))),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(0.0),
                child: (model.game != null)
                    ? Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              child: getTable("R", _scrollController1),
                            ),
                          ),
                          SizedBox(
                            height: model.fontSize * 2.1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 00),
                              child: getTable("T", null),
                            ),
                          ),
                          getKeyboard()
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Click New Game to start.", style: Theme.of(context).textTheme.headline4)],
                          )
                          // Text("Game", style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
              ),
            ));
  }

  DataTable2 getTable(String roundType, ScrollController? scrollController) {
    return DataTable2(
      columnSpacing: 2,
      horizontalMargin: 2,
      minWidth: 400,
      scrollController: scrollController,
      headingRowHeight: roundType == "R" ? (model.fontSize * 2) : 0,
      dividerThickness: roundType == "R" ? 0 : null,
      dataRowHeight: model.fontSize * 2.1,
      columns: model.game!.players
          .map((e) => DataColumn(
                label: roundType == "R"
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: model.fontSize * 0.15),
                        child: Text(e.name, style: TextStyle(fontSize: model.fontSize, color: Colors.blue.shade800)),
                      )
                    : Container(),
              ))
          .toList()
        ..insert(
          0,
          DataColumn2(
            label: roundType == "R"
                ? Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: model.fontSize * 0.15), child: const Text(""))
                : Container(),
          ),
        ),
      rows: model.game!.rounds
          .where((e) => e.roundType == roundType)
          .map((e) => DataRow(
              cells: e.playerRounds!
                  .map((c) => DataCell(
                        onTap: () => roundType == "R" ? selectRound(e.roundNo, c.playerNo) : null,
                        Container(
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                color: (e.roundNo == model.game!.currentRoundNo && c.playerNo == model.game!.currentPlayerNo)
                                    ? (model.game!.currentRoundState == 0)
                                        ? Colors.blue.shade200
                                        : Colors.green.shade200
                                    : Colors.grey.shade200),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: model.fontSize * 0.15),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (e.roundType == "R")
                                  Text(
                                    (c.tricks != null || c.takes != null) ? "${c.tricks ?? ""} / ${c.takes ?? ""}" : "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: model.fontSize,
                                    ),
                                  ),
                                Text(
                                  c.score != null ? c.score.toString() : "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: model.fontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                      ))
                  .toList()
                ..insert(
                    0,
                    DataCell(
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(14)),
                              color: (e.roundNo == model.game!.currentRoundNo)
                                  ? (model.game!.currentRoundState == 0)
                                      ? Colors.blue.shade800
                                      : Colors.green.shade800
                                  : Colors.grey.shade500),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: model.fontSize * 0.15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (e.roundType == "R")
                                Text(e.roundCards.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: model.fontSize,
                                    )),
                              if (e.roundType == "R")
                                Text((e.roundNo == model.game!.currentRoundNo) ? ((model.game!.currentRoundState == 0) ? "Tricks" : "Takes") : "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: model.fontSize,
                                    )),
                              if (e.roundType == "T")
                                Text("",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: model.fontSize,
                                    )),
                              if (e.roundType == "T")
                                Text("TOTAL:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: model.fontSize,
                                    )),
                            ],
                          )),
                    ))))
          .toList(),
    );
  }

  Widget getKeyboard() {
    var round = model.game!.rounds[model.game!.currentRoundNo];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: model.fontSize * 3,
                  height: model.fontSize * 4 + 5,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentPlayerNo > 0) {
                            model.game!.currentPlayerNo--;
                          }
                        });
                      },
                      child: Icon(Icons.arrow_back_ios_rounded, size: model.fontSize + 2))),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                            onPressed: round.roundCards < 1
                                ? null
                                : () {
                                    setAmount(1);
                                  },
                            child: Text("1",
                                style: TextStyle(
                                  fontSize: model.fontSize,
                                )),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 2
                                  ? null
                                  : () {
                                      setAmount(2);
                                    },
                              child: Text("2",
                                  style: TextStyle(
                                    fontSize: model.fontSize,
                                  )))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 3
                                  ? null
                                  : () {
                                      setAmount(3);
                                    },
                              child: Text("3",
                                  style: TextStyle(
                                    fontSize: model.fontSize,
                                  )))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 4
                                  ? null
                                  : () {
                                      setAmount(4);
                                    },
                              child: Text("4",
                                  style: TextStyle(
                                    fontSize: model.fontSize,
                                  )))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 5
                                  ? null
                                  : () {
                                      setAmount(5);
                                    },
                              child: Text("5",
                                  style: TextStyle(
                                    fontSize: model.fontSize,
                                  )))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: model.fontSize * 4,
                          height: model.fontSize * 2,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 6
                                  ? null
                                  : () {
                                      setAmount(6);
                                    },
                              child: Text("6",
                                  style: TextStyle(
                                    fontSize: model.fontSize,
                                  )))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: model.fontSize * 3,
                  height: model.fontSize * 4 + 5,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentPlayerNo < model.game!.playerCount - 1) {
                            model.game!.currentPlayerNo++;
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: model.fontSize + 2,
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: model.fontSize * 8,
                  height: model.fontSize * 2,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentRoundState == 0 && model.game!.currentRoundNo > 0) {
                            model.game!.currentRoundNo--;
                            model.game!.currentRoundState = 1;
                            model.game!.currentPlayerNo = 0;
                          } else {
                            model.game!.currentRoundState = 0;
                            model.game!.currentPlayerNo = 0;
                          }

                          // _scrollController1.animateTo(model.game!.currentRoundNo * 50 - 400,
                          //     duration: const Duration(milliseconds: 100), curve: Curves.ease);
                        });
                      },
                      child: Text((model.game!.currentRoundState == 1) ? "Tricks" : "Prev Round",
                          style: TextStyle(
                            fontSize: model.fontSize,
                          )))),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: model.fontSize * 4,
                  height: model.fontSize * 2,
                  child: ElevatedButton(
                      child: Text("0",
                          style: TextStyle(
                            fontSize: model.fontSize,
                          )),
                      onPressed: () {
                        setAmount(0);
                      })),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: model.fontSize * 8,
                  height: model.fontSize * 2,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentRoundState == 1 && model.game!.currentRoundNo < model.game!.rounds.length - 2) {
                            model.game!.currentRoundNo++;
                            model.game!.currentRoundState = 0;
                            model.game!.currentPlayerNo = 0;
                          } else {
                            model.game!.currentRoundState = 1;
                            model.game!.currentPlayerNo = 0;
                          }
                          //_scrollController1.animateTo(model.game!.currentRoundNo * 50 - 400,duration: const Duration(milliseconds: 100), curve: Curves.ease);
                        });
                      },
                      child: Text((model.game!.currentRoundState == 1) ? "Next Round" : "Takes",
                          style: TextStyle(
                            fontSize: model.fontSize,
                          )))),
            ],
          )
        ],
      ),
    );
  }

  setAmount(int count) {
    if (model.game!.currentRoundState == 0) {
      setTricks(count);
    } else {
      setTakes(count);
    }
  }

  setTricks(int count) {
    setState(() {
      var round = model.game!.rounds[model.game!.currentRoundNo].playerRounds![model.game!.currentPlayerNo];
      round.tricks = count;
      calcSore();

      if (model.game!.currentPlayerNo < model.game!.playerCount - 1) {
        model.game!.currentPlayerNo++;
      } else {
        model.game!.currentPlayerNo = 0;
      }
    });
  }

  setTakes(int count) {
    setState(() {
      var round = model.game!.rounds[model.game!.currentRoundNo].playerRounds![model.game!.currentPlayerNo];
      round.takes = count;
      calcSore();

      if (model.game!.currentPlayerNo < model.game!.playerCount - 1) {
        model.game!.currentPlayerNo++;
      } else {
        model.game!.currentPlayerNo = 0;
      }
    });
  }

  calcSore() {
    var roundCell = model.game!.rounds[model.game!.currentRoundNo].playerRounds![model.game!.currentPlayerNo];

    int? guess = roundCell.tricks;
    int? takes = roundCell.takes;

    int? score;
    if (guess != null && takes != null) {
      if (guess == takes) {
        score = takes * 50 + 50;

        if (model.game!.rounds[model.game!.currentRoundNo].roundCards == 1) {
          score = score * 3;
        }
      } else {
        score = takes * 10;
      }
    }
    roundCell.score = score;

    var totalCell = model.game!.rounds[model.game!.rounds.length - 1].playerRounds![model.game!.currentPlayerNo];

    int total = 0;
    for (var r in model.game!.rounds.where((e) => e.roundType == "R")) {
      if (r.playerRounds![model.game!.currentPlayerNo].score != null) total += r.playerRounds![model.game!.currentPlayerNo].score!;
    }

    totalCell.score = total;
  }

  selectRound(roundNo, playerNo) {
    setState(() {
      //model.game!.currentRoundNo = roundNo;
      model.game!.currentPlayerNo = playerNo;
    });
  }

  newGameDialog() {
    showDialog(
        context: context,
        builder: (context) {
          List<String>? players;
          if (model.game != null) {
            players = model.game!.players.map((e) => e.name).toList();
          }

          return NewGameDialog(
              players: players,
              onSubmit: (players) {
                if (players.length > 1) {
                  setState(() {
                    model.buildGame(players);
                  });
                }
              });
        });
  }
}
