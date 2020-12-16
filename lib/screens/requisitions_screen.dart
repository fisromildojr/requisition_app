import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisition_app/models/auth_data.dart';
import 'package:requisition_app/models/requisition.dart';
import 'package:requisition_app/utils/app_routes.dart';

class RequisitionsScreen extends StatefulWidget {
  @override
  _RequisitionsScreenState createState() => _RequisitionsScreenState();
}

class _RequisitionsScreenState extends State<RequisitionsScreen> {
  void _selectRequisition(
      BuildContext context, Requisition requisition, AuthData user) {
    Navigator.of(context).pushNamed(
      AppRoutes.REQUISITION_DETAILS,
      arguments: requisition,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as AuthData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Requisições'),
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
      body: StreamBuilder(
        stream: user.isAdmin
            ? FirebaseFirestore.instance
                .collection('requisitions')
                .orderBy('createdAt', descending: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('requisitions')
                // .orderBy('createdAt', descending: true)
                .where('idUserRequested', isEqualTo: user.id)
                // .orderBy('idUserRequested', descending: true)
                .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('ERRO: ' + snapshot.error.toString());
          }

          final documents = snapshot.data.documents;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, i) {
              final requisition = Requisition(
                id: documents[i].id,
                solvedIn: documents[i]['solvedIn'],
                createdAt: documents[i]['createdAt'],
                description: documents[i]['description'],
                idDepartment: documents[i]['idDepartment'],
                idProvider: documents[i]['idProvider'],
                idSector: documents[i]['idSector'],
                idUserRequested: documents[i]['idUserRequested'],
                nameDepartment: documents[i]['nameDepartment'],
                nameProvider: documents[i]['nameProvider'],
                nameSector: documents[i]['nameSector'],
                nameUserRequested: documents[i]['nameUserRequested'],
                paymentForecastDate: documents[i]['paymentForecastDate'],
                purchaseDate: documents[i]['purchaseDate'],
                solvedByName: documents[i]['solvedByName'],
                solvedById: documents[i]['solvedById'],
                status: documents[i]['status'],
                value: documents[i]['value'],
              );
              return GestureDetector(
                onTap: user.isAdmin
                    ? () => _selectRequisition(context, requisition, user)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: documents[i]['status'] == 'PENDENTE'
                        ? Colors.amber
                        : documents[i]['status'] == 'NEGADO'
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
                            documents[i]['nameDepartment'] +
                                DateFormat(' - dd/MM/y - HH:MM')
                                    .format(documents[i]['createdAt'].toDate()),
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
                          Text(documents[i]['description']),
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
                          Text(documents[i]['nameProvider']),
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
                          Text(documents[i]['nameDepartment']),
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
                          Text(documents[i]['nameSector']),
                        ],
                      ),
                      if (user.isAdmin)
                        Row(
                          children: [
                            Text(
                              'Solicitado por: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(documents[i]['nameUserRequested']),
                          ],
                        ),
                      if (documents[i]['status'] == 'PENDENTE')
                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(documents[i]['status']),
                          ],
                        )
                      else if (documents[i]['status'] == 'NEGADO')
                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Negado por ${documents[i]['solvedByName']}'),
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
                            Text(
                                'Aprovado por ${documents[i]['solvedByName']}'),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'R\$ ${documents[i]['value']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // return Text('Chegou');
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
      ),
    );
  }
}
