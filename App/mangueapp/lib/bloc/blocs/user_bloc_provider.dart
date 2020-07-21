import 'package:mangueapp/models/classes/graph.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mangueapp/models/classes/user.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();

  Stream<User> get getUser => _userGetter.stream;

  registerUser(String username, String firstname, String lastname, String password, String email) async {
    User user = await _repository.registerUser(username, firstname, lastname, password, email);
    _userGetter.sink.add(user);
  }

  signinUser(String username, String password, String apiKey) async {
    User user = await _repository.signinUser(username, password, apiKey);
    _userGetter.sink.add(user);
  }

  dispose() {
    _userGetter.close();
  }
}

class GraphBloc {
  final _repository = Repository();
  final _graphGetter = PublishSubject<List<Graph>>();

  Stream<List<Graph>> get getGraphs => _graphGetter.stream;

  getGraphics(String apiKey) async {
    List<Graph> graphs = await _repository.getGraphs(apiKey);
    _graphGetter.sink.add(graphs);
  }

  dispose() {
    _graphGetter.close();
  }
}

final graphsBloc = GraphBloc();
final userBloc = UserBloc();