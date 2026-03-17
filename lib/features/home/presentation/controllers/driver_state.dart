abstract class DriverState {}

class DriverInitialState extends DriverState {}

class DriverLoadingState extends DriverState {}

class DriverSuccessState extends DriverState {}

class DriverErrorState extends DriverState {
  final String message;
  DriverErrorState(this.message);
}
