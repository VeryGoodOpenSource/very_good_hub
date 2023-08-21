import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required TokenProvider tokenProvider,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _tokenProvider = tokenProvider,
        super(const AppInitial()) {
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionLoggedOff>(_onSessionLoggedOff);

    _sessionSubscription = _authenticationRepository.session.listen((event) {
      if (event != null) {
        _tokenProvider.applyToken(event.token);
        add(SessionLoaded(session: event));
      } else {
        add(const SessionLoggedOff());
        _tokenProvider.clear();
      }
    });

    tokenProvider.current.then((value) async {
      if (value != null) {
        final session = await _userRepository.getUserSession();
        add(SessionLoaded(session: session));
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final TokenProvider _tokenProvider;
  late StreamSubscription<Session?> _sessionSubscription;

  void _onSessionLoaded(
    SessionLoaded event,
    Emitter<AppState> emit,
  ) {
    emit(AppAuthenticated(session: event.session));
  }

  void _onSessionLoggedOff(
    SessionLoggedOff event,
    Emitter<AppState> emit,
  ) {
    emit(const AppInitial());
  }

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
