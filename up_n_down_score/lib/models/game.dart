import '../core/constants.dart';

class Game {
  List<Player> players = [];
  int playerCount = 0;
  int currentRoundNo = 0;
  int currentRoundState = 0;
  int currentPlayerNo = 0;
  List<GameRound> rounds = [];

  Game({required List<String> players}) {
    this.players = [];
    for (int i = 0; i < players.length; i++) {
      this.players.add(Player(i, players[i]));
    }

    playerCount = this.players.length;
    currentRoundNo = 0;
    currentRoundState = 0;
    currentPlayerNo = 0;

    rounds = [];

    // gameCardsCount
    //     .map((e) => GameRound(id: gameCardsCount.indexOf(e), roundCarts: e, playerRounds: players.map((p) => PlayerRound()).toList()))
    //     .toList();

    for (int i = 0; i < gameCardsCount.length; i++) {
      rounds.add(GameRound(
          roundType: "R", roundNo: i, roundCards: gameCardsCount[i], playerRounds: this.players.map((p) => PlayerRound(p.playerNo)).toList()));
    }

    rounds.add(GameRound(roundType: "T", roundNo: -1, roundCards: -1, playerRounds: this.players.map((p) => PlayerRound(p.playerNo)).toList()));
  }
}

class GameRound {
  String roundType = "R";
  int roundNo = 0;
  int roundCards = 0;
  List<PlayerRound>? playerRounds = [];

  GameRound({required this.roundType, required this.roundNo, required this.roundCards, this.playerRounds});
}

class PlayerRound {
  int playerNo;
  int? tricks;
  int? takes;
  int? score;

  PlayerRound(this.playerNo, {this.tricks, this.takes, this.score});
}

class Player {
  int playerNo;
  String name;
  Player(this.playerNo, this.name);
}
