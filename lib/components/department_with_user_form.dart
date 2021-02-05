import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:requisition_app/components/department_with_user_listtile.dart';
import 'package:requisition_app/models/auth_data.dart';
import 'package:requisition_app/models/department.dart';

class DepartmentWithUserForm extends StatefulWidget {
  final void Function(Department) onSubmit;
  final AuthData user;
  DepartmentWithUserForm(this.onSubmit, this.user);

  @override
  _DepartmentWithUserFormState createState() => _DepartmentWithUserFormState();
}

class _DepartmentWithUserFormState extends State<DepartmentWithUserForm> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('departments').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data.documents;
          return SingleChildScrollView(
              child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Departamentos:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, i) {
                        if (documents.length > 0) {
                          final Department department = Department(
                            id: documents[i].id,
                            name: documents[i]['name'],
                          );
                          return Card(
                            elevation: 1,
                            child: ListTileDepartmentWithUser(
                                department, widget.user),
                          );
                        } else {
                          return Card(
                            elevation: 1,
                            child: FittedBox(
                              child: Text(
                                'Nenhum departamento cadastrado...',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
