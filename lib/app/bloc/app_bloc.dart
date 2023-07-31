import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hub_domain/hub_domain.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AppInitial()) {
    on<AuthenticationRequested>(_onAuthenticationRequested);
    on<SessionLoaded>(_onSessionLoaded);

    _sessionSubscription = _authenticationRepository.session.listen((event) {
      if (event != null) {
        add(SessionLoaded(session: event));
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<Session?> _sessionSubscription;

  Future<void> _onAuthenticationRequested(
    AuthenticationRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(const AppLoading());
      await _authenticationRepository.login(
        username: event.username,
        password: event.password,
      );
    } catch (e, s) {
      addError(e, s);
      emit(const AppAuthenticationFailed());
    }
  }

  void _onSessionLoaded(
    SessionLoaded event,
    Emitter<AppState> emit,
  ) {
    emit(AppAuthenticated(session: event.session));
  }

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
