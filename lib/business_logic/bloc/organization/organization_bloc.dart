import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:reservation_app/business_logic/models/organization_model.dart';
import 'package:reservation_app/business_logic/repositories/organization/organization_repository.dart';
import 'package:reservation_app/tools/enum/role.dart';
part 'organization_event.dart';
part 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  OrganizationBloc(OrganizationRepository repository)
      : super(OrganizationInitial()) {
    on<OrganizationPobierz>((event, emit) async {
      if (event.stanowisko == Role.admin) {
        await emit.forEach(repository.streamSpolkeAdmin(),
            onData: ((List<OrganizationModel> data) {
          return OrganizationPobrane(data);
        }));
      } else if (event.stanowisko == Role.manager) {
        // List<Spolka> lista = [];
        // lista.add(await repozytorium.streamSpolke(nazwa: event.nazwa));
        await emit.forEach(repository.streamOrganization(orgRef: event.orgRef),
            onData: ((OrganizationModel data) {
          return OrganizationPobrane([data]);
        }));

        // Spolka spolka =
        //     await repozytorium.streamSpolke(nazwa: event.nazwa);
        // emit(SpolkaPobrane([spolka]));
      }
    });
  }
}
