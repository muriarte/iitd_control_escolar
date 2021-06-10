import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_state.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';

class StudentListing extends StatelessWidget {
  StudentListing({
    required this.itemSelectedCallback,
    this.selectedItem,
  });

  final ValueChanged<Student> itemSelectedCallback;
  final Student? selectedItem;

  @override
  Widget build(BuildContext context) {
    var _cubit = BlocProvider.of<StudentListingBloc>(context);
    if (_cubit.state is StudentListingInitialState) _cubit.getStudentList();
    if (_cubit.state is! StudentListingLoadedState) return Container();
    List<Student> items = (_cubit.state as StudentListingLoadedState).students;
    return Column(
      children: <Widget>[
        buildFiltersPanel(_cubit),
        studentListing(items, _cubit),
      ],
    );
  }

  ExpansionPanelList buildFiltersPanel(StudentListingBloc _cubit) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        _cubit.setShowFilters(!isExpanded);
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Filtros"),
            );
          },
          body: filtersForm(_cubit),
          isExpanded: (_cubit.state as StudentListingLoadedState).showFilters,
        ),
      ],
    );
  }

  Widget filtersForm(StudentListingBloc _cubit) {
    var nombreController = TextEditingController();
    nombreController.value = TextEditingValue(
        text: (_cubit.state as StudentListingLoadedState).nameFilter);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("Nombre:"),
              Expanded(
                child: TextField(
                  controller: nombreController,
                  onEditingComplete: () => {
                    _cubit.setFilters(
                        nombreController.text,
                        (_cubit.state as StudentListingLoadedState)
                            .activesFilter)
                  },
                ),
              ),
              SizedBox(
                width: 70,
                child: TextButton(
                  child: Text('Filtrar'),
                  onPressed: () => {
                    _cubit.setFilters(
                        nombreController.text,
                        (_cubit.state as StudentListingLoadedState)
                            .activesFilter)
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Solo activos:"),
              Checkbox(
                onChanged: (value) =>
                    {_cubit.setFilters(nombreController.text, value ?? false)},
                value:
                    (_cubit.state as StudentListingLoadedState).activesFilter,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget studentListing(List<Student> items, StudentListingBloc _cubit) {
    var st = _cubit.state as StudentListingLoadedState;
    var itemsFiltrados = items.where((e) =>
        ((st.nameFilter.trim().length == 0 ||
            e.nombres.toLowerCase().contains(st.nameFilter.toLowerCase()) ||
            e.apellidos.toLowerCase().contains(st.nameFilter.toLowerCase()))) &&
        (st.activesFilter == false || e.activo == "S"));
    return Expanded(
      child: Stack(
        children: [
          ListView(
            children: itemsFiltrados.map((item) {
              return ListTile(
                title: Text(item.apellidos + ", " + item.nombres),
                trailing: TextButton(
                  child: const Icon(Icons.delete),
                  onPressed: () {
                    _cubit.deleteItemIfConfirmed(item.id);
                  },
                ),
                onTap: () => itemSelectedCallback(item),
                selected: selectedItem == item,
              );
            }).toList(),
          ),
          Positioned(
            right: 30,
            bottom: 15,
            child: FloatingActionButton(
              onPressed: () => {
                _cubit.newItem().then((value) => itemSelectedCallback(value))
              },
              child: const Icon(Icons.add_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
