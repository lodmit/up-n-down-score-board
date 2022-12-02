import '../../models/game.dart';
import '../../shared/base_model.dart';

class HomeModel extends BaseModel {
  Game? game;

  buildGame(List<String> players) {
    game = Game(players: players);
  }
}
