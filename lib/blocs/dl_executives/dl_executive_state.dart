part of 'dl_executive_cubit.dart';

abstract class DlExecutivesState extends Equatable {}

class DlExecutivesLoading extends DlExecutivesState {
  @override
  List<Object?> get props => [];
}

class DlExecutivesSuccess extends DlExecutivesState {
  final List<DlExecutiveModel> dlExecutives;

 DlExecutivesSuccess(this.dlExecutives);

  @override
  List<Object?> get props => [dlExecutives];
}

class DlExecutivesFailure extends DlExecutivesState {
  final String message;

  DlExecutivesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
