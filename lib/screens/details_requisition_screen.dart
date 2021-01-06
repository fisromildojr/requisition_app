import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    FirebaseFirestore.instance
        .collection('requisitions')
        .doc(requisition.id)
        .update({
      'solvedByName': user.get('name'),
      'solvedById': userAuth.uid,
      'status': 'APROVADO',
      'approvedIn': Timestamp.now(),
    }).then((_) {
      if (requisition.emailProvider.isNotEmpty ||
          requisition.emailProvider != null)
        FirebaseFirestore.instance.collection('mail').add({
          'to': requisition.emailProvider,
          'message': {
            'subject': 'Requisição Aprovada',
            'text': 'Foi aprovada uma requisição para o colaborador ' +
                requisition.nameUserRequested,
            'html': "<div style='margin:0 auto'><table style='text-align:center;font-size:15px;border:1px'><tr><td><br>Requisição</td></tr><tr><td style='font-size:20px;font-weight:bold'>" +
                requisition.id +
                "</td></tr><tr><td><br>Data da Aprova&ccedil;&atilde;o</td></tr><tr><td style='font-size:20px;font-weight:bold'>" +
                DateFormat('dd/MM/y').format(requisition.createdAt.toDate()) +
                "</td></tr><tr><td><br>Valor</td></tr><tr><td style='font-size:20px;font-weight:bold'>R\$ " +
                requisition.value.toStringAsFixed(2) +
                "</td></tr><tr><td><br>Solicitada por:</td></tr><tr><td style='font-size:20px;font-weight:bold'>" +
                requisition.nameUserRequested +
                "</td></tr><tr><td><br>" +
                requisition.status +
                " por </td></tr><tr><td style='font-size:20px;font-weight:bold'>" +
                requisition.solvedByName +
                "</td></tr></table></div>",
          },
        });
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
      'solvedIn': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userAuth = FirebaseAuth.instance.currentUser;
    final requisition =
        ModalRoute.of(context).settings.arguments as Requisition;
    final user = FirebaseAuth.instance.currentUser;
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Text(
                          requisition.nameDepartment +
                              DateFormat(' - dd/MM/y - HH:MM')
                                  .format(requisition.createdAt.toDate()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Descrição: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            requisition.description,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Fornecedor: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(requisition.nameProvider),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Departamento: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(requisition.nameDepartment),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Centro de Custo: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(requisition.nameSector),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Categoria: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(requisition.nameCategory),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          'Solicitado por: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(requisition.nameUserRequested),
                        ),
                      ],
                    ),
                  ),
                  if (requisition.status == 'PENDENTE')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(requisition.status),
                          ),
                        ],
                      ),
                    )
                  else if (requisition.status == 'NEGADO')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child:
                                Text('Negado por ${requisition.solvedByName}'),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                                'Aprovado por ${requisition.solvedByName}'),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${requisition.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (requisition.status == 'NEGADO' &&
                              requisition.solvedById == user.uid ||
                          requisition.status == 'PENDENTE')
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
                      if (requisition.status == 'NEGADO' &&
                              requisition.solvedById == user.uid ||
                          requisition.status == 'PENDENTE')
                        SizedBox(
                          width: 20,
                        ),
                      if (requisition.status == 'PENDENTE')
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
