abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashSuccessState extends SplashState {
  final String route;
  SplashSuccessState(this.route);
}

class SplashErrorState extends SplashState {
  final String message;
  SplashErrorState(this.message);
}
