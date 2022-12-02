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
                  SizedBox(
                      width: 100,
                      // height: 30,
                      child: ElevatedButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                          onPressed: () => newGameDialog(),
                          child: Text("New Game"))),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(0.0),
                child: (model.game != null)
                    ? Column(
                        children: [
                          // Text("Game", style: Theme.of(context).textTheme.headline6),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              child: getTable("R", _scrollController1),
                            ),
                          ),

                          SizedBox(
                            height: 60,
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
      minWidth: 100,
      scrollController: scrollController,
      headingRowHeight: roundType == "R" ? 50 : 0,
      dividerThickness: roundType == "R" ? 0 : null,
      dataRowHeight: 50,
      columns: model.game!.players
          .map((e) => DataColumn(
                label: roundType == "R"
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(e.name),
                      )
                    : Container(),
              ))
          .toList()
        ..insert(
          0,
          DataColumn2(
            label:
                roundType == "R" ? Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: const Text("")) : Container(),
          ),
        ),
      rows: model.game!.rounds
          .where((e) => e.roundType == roundType)
          .map((e) => DataRow(
              cells: e.playerRounds!
                  .map((c) => DataCell(
                        onTap: () => roundType == "R" ? selectRound(e.roundNo, c.playerNo) : null,
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                color: (e.roundNo == model.game!.currentRoundNo && c.playerNo == model.game!.currentPlayerNo)
                                    ? (model.game!.currentRoundState == 0)
                                        ? Colors.blue.shade200
                                        : Colors.green.shade200
                                    : Colors.grey.shade200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (e.roundType == "R") Text((c.tricks != null || c.takes != null) ? "${c.tricks ?? ""} / ${c.takes ?? ""}" : ""),
                                if (e.roundType == "T") Text(""),
                                Text(
                                  c.score != null ? c.score.toString() : "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (e.roundType == "R") Text(e.roundCards.toString(), style: const TextStyle(color: Colors.white)),
                              if (e.roundType == "R")
                                Text((e.roundNo == model.game!.currentRoundNo) ? ((model.game!.currentRoundState == 0) ? "Tricks" : "Takes") : "",
                                    style: const TextStyle(color: Colors.white)),
                              if (e.roundType == "T") Text("", style: const TextStyle(color: Colors.white)),
                              if (e.roundType == "T") Text("TOTAL:", style: const TextStyle(color: Colors.white)),
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
            children: [
              SizedBox(
                  width: 50,
                  height: 130,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentPlayerNo > 0) {
                            model.game!.currentPlayerNo--;
                          }
                        });
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                      ))),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: round.roundCards < 1
                                ? null
                                : () {
                                    setAmount(1);
                                  },
                            child: const Text("1"),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 2
                                  ? null
                                  : () {
                                      setAmount(2);
                                    },
                              child: const Text("2"))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 3
                                  ? null
                                  : () {
                                      setAmount(3);
                                    },
                              child: const Text("3"))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 4
                                  ? null
                                  : () {
                                      setAmount(4);
                                    },
                              child: const Text("4"))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 5
                                  ? null
                                  : () {
                                      setAmount(5);
                                    },
                              child: const Text("5"))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: round.roundCards < 6
                                  ? null
                                  : () {
                                      setAmount(6);
                                    },
                              child: const Text("6"))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 80,
                          height: 40,
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

                                  _scrollController1.animateTo(model.game!.currentRoundNo * 50 - 400,
                                      duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                });
                              },
                              child: Text((model.game!.currentRoundState == 1) ? "Tricks" : "Prev Round"))),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                              child: const Text("0"),
                              onPressed: () {
                                setAmount(0);
                              })),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 80,
                          height: 40,
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
                                  _scrollController1.animateTo(model.game!.currentRoundNo * 50 - 400,
                                      duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                });
                              },
                              child: Text((model.game!.currentRoundState == 1) ? "Next Round" : "Takes"))),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: 50,
                  height: 130,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        setState(() {
                          if (model.game!.currentPlayerNo < model.game!.playerCount - 1) {
                            model.game!.currentPlayerNo++;
                          }
                        });
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ))),
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
      model.game!.currentRoundNo = roundNo;
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
