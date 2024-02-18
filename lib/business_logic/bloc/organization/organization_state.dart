part of 'organization_bloc.dart';

abstract class OrganizationState {}

class OrganizationInitial extends OrganizationState {}

class OrganizationPobrane extends OrganizationState {
  final List<OrganizationModel> organization;
  OrganizationPobrane(this.organization);
}
