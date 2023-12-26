part of 'dl_executive_cubit.dart';

abstract class DlExecutivesState extends Equatable {}

abstract class DlExecutivesResponseState extends DlExecutivesState {
  final List<DlExecutiveModel> dlExecutives;

  DlExecutivesResponseState(this.dlExecutives);
}

class DlExecutivesLoading extends DlExecutivesState {
  @override
  List<Object?> get props => [];
}
class DlExecutivesEmpty extends DlExecutivesState {
  @override
  List<Object?> get props => [];
}

class DlExecutivesSuccess extends DlExecutivesResponseState {
  DlExecutivesSuccess(List<DlExecutiveModel> dlExecutives) : super(dlExecutives);

  @override
  List<Object?> get props => [dlExecutives];
}

class DlExecutivesFailure extends DlExecutivesResponseState {
  final String message;

  DlExecutivesFailure(this.message, List<DlExecutiveModel> dlExecutives) : super(dlExecutives);

  @override
  List<Object?> get props => [message];
}
