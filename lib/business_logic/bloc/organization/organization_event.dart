part of 'organization_bloc.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object> get props => [];
}

class OrganizationPobierz extends OrganizationEvent {
  final DocumentReference orgRef;
  final Role stanowisko;
  const OrganizationPobierz(this.orgRef, this.stanowisko);
}
