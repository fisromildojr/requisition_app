import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:requisition_app/models/auth_data.dart';
import 'package:requisition_app/models/requisition.dart';
import 'package:requisition_app/utils/app_routes.dart';

class RequisitionDetailsScreen extends StatefulWidget {
  @override
  _RequisitionDetailsScreenState createState() =>
      _RequisitionDetailsScreenState();
}

class _RequisitionDetailsScreenState extends State<RequisitionDetailsScreen> {
  Future<void> _aproveRequisition(
      BuildContext context, Requisition requisition) async {
    Navigator.of(context).pop();
    final userAuth = FirebaseAuth.instance.currentUser;
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth.uid)
        .get();
    await FirebaseFirestore.instance
        .collection('requisitions')
        .doc(requisition.id)
        .update({
      'solvedByName': user.get('name'),
      'solvedById': userAuth.uid,
      'status': 'APROVADO',
      'approvedIn': Timestamp.now(),
    });
  }

  Future<void> _disapproveRequisition(
      BuildContext context, Requisition requisition) async {
    Navigator.of(context).pop();
    final userAuth = FirebaseAuth.instance.currentUser;
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth.uid)
        .get();
    await FirebaseFirestore.instance
        .collection('requisitions')
        .doc(requisition.id)
        .update({
      'solvedByName': user.get('name'),
      'solvedById': userAuth.uid,
      'status': 'NEGADO',
      'solvedIn': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userAuth = FirebaseAuth.instance.currentUser;
    final requisition =
        ModalRoute.of(context).settings.arguments as Requisition;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (item) {
                if (item == 'logout') {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed(
                    AppRoutes.HOME,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () => null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: requisition.status == 'PENDENTE'
                    ? Colors.amber
                    : requisition.status == 'NEGADO'
                        ? Colors.red
                        : Colors.green,
              ),
              padding: EdgeInsets.all(6),
              margin: EdgeInsets.all(2),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        requisition.nameDepartment +
                            DateFormat(' - dd/MM/y - HH:MM')
                                .format(requisition.createdAt.toDate()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Descrição: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(requisition.description),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Fornecedor: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(requisition.nameProvider),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Departamento: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(requisition.nameDepartment),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Centro de Custo: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(requisition.nameSector),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Solicitado por: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(requisition.nameUserRequested),
                    ],
                  ),
                  if (requisition.status == 'PENDENTE')
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(requisition.status),
                      ],
                    )
                  else if (requisition.status == 'NEGADO')
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Negado por ${requisition.solvedByName}'),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Aprovado por ${requisition.solvedByName}'),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${requisition.value}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (requisition.status != 'APROVADO')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RaisedButton(
                              elevation: 5,
                              color: Colors.green,
                              child: Text(
                                'Aprovar',
                              ),
                              onPressed: () => _aproveRequisition(
                                context,
                                requisition,
                              ),
                            ),
                          ],
                        ),
                      if (requisition.status != 'APROVADO')
                        SizedBox(
                          width: 20,
                        ),
                      if (requisition.status == 'APROVADO' ||
                          requisition.status == 'PENDENTE')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RaisedButton(
                              elevation: 5,
                              color: Colors.red,
                              child: Text(
                                'Reprovar',
                              ),
                              onPressed: () => _disapproveRequisition(
                                context,
                                requisition,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
