import 'package:requisition_app/components/reportys_form.dart';
import 'package:requisition_app/models/auth_data.dart';
import 'package:requisition_app/models/requisition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Future futureFilter = FirebaseFirestore.instance
      .collection('requisitions')
      .where('status', isEqualTo: 'APROVADO')
      .orderBy('createdAt', descending: true)
      .get();

  _openFilterReportsFormModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ReportsForm(filter);
      },
    );
  }

  filter(dynamic stringFilter) {
    Navigator.of(context).pop();
    setState(() {
      this.futureFilter = stringFilter as Future;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as AuthData;
    final appBar = AppBar(
      title: Text('Relatório'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_alt),
          onPressed: () => _openFilterReportsFormModal(context),
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
          future: futureFilter,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final documents = snapshot.data.documents;
            double totalValue = 0;
            for (var i = 0; i < documents.length; i++) {
              totalValue += documents[i]['value'];
            }

            return Column(
              children: [
                Container(
                  height: availableHeight * 0.9,
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (ctx, i) {
                      final requisition = Requisition(
                        id: documents[i].id,
                        solvedIn: documents[i]['solvedIn'],
                        createdAt: documents[i]['createdAt'],
                        description: documents[i]['description'],
                        idCategory: documents[i]['idCategory'],
                        idDepartment: documents[i]['idDepartment'],
                        idProvider: documents[i]['idProvider'],
                        idSector: documents[i]['idSector'],
                        idUserRequested: documents[i]['idUserRequested'],
                        nameCategory: documents[i]['nameCategory'],
                        nameDepartment: documents[i]['nameDepartment'],
                        nameProvider: documents[i]['nameProvider'],
                        emailProvider: documents[i]['emailProvider'],
                        number: documents[i]['number'],
                        docProvider: documents[i]['docProvider'],
                        nameSector: documents[i]['nameSector'],
                        nameUserRequested: documents[i]['nameUserRequested'],
                        paymentForecastDate: documents[i]
                            ['paymentForecastDate'],
                        purchaseDate: documents[i]['purchaseDate'],
                        solvedByName: documents[i]['solvedByName'],
                        solvedById: documents[i]['solvedById'],
                        status: documents[i]['status'],
                        value: documents[i]['value'],
                      );
                      return GestureDetector(
                        onTap: () => null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: documents[i]['status'] == 'PENDENTE'
                                ? Colors.amber[400]
                                : documents[i]['status'] == 'NEGADO'
                                    ? Colors.red[400]
                                    : Colors.green[400],
                          ),
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        documents[i]['nameDepartment'] +
                                            ' - ' +
                                            DateFormat('dd/MM/y - HH:mm:ss')
                                                .format(documents[i]
                                                        ['createdAt']
                                                    .toDate()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      documents[i]['number'] != null
                                          ? 'Nº: ${documents[i]['number'].toString()}'
                                          : 'Nº: ---',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Descrição: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      documents[i]['description'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                  Flexible(
                                    child: Text(
                                      documents[i]['nameProvider'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                  Flexible(
                                    child: Text(
                                      documents[i]['nameDepartment'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                  Flexible(
                                    child: Text(
                                      documents[i]['nameSector'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Categoria: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      documents[i]['nameCategory'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                    Flexible(
                                      child: Text(
                                        documents[i]['nameUserRequested'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                                    Flexible(
                                      child: Text(
                                        documents[i]['status'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                                    Flexible(
                                      child: Text(
                                        'Negado por ${documents[i]['solvedByName']}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                                    Flexible(
                                      child: Text(
                                        'Aprovado por ${documents[i]['solvedByName']}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'R\$ ${documents[i]['value'].toStringAsFixed(2)}',
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
                  ),
                ),
                Container(
                  height: availableHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Qtd: ${documents.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Total: R\$ ${totalValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
