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
    if (_cubit.state is! StudentListingLoadedState) return Container();
    List<Student> items = (_cubit.state as StudentListingLoadedState).students;
    return ListView(
      children: items.map((item) {
        return ListTile(
          title: Text(item.firstName),
          onTap: () => itemSelectedCallback(item),
          selected: selectedItem == item,
        );
      }).toList(),
    );
  }
}
