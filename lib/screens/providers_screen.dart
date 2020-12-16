import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:requisition_app/components/provider_form.dart';
import 'package:requisition_app/models/provider.dart';
import 'package:requisition_app/utils/app_routes.dart';

class ProvidersScreen extends StatefulWidget {
  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  _openProviderFormModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ProviderForm(_addProvider);
      },
    );
  }

  Future<void> _addProvider(Provider provider) async {
    Navigator.of(context).pop();

    // final Department newDepartment = Department(
    //   id: null,
    //   name: name,
    // );

    await FirebaseFirestore.instance.collection('providers').add({
      'fantasyName': provider.fantasyName,
      'email': provider.email,
      'address': provider.address,
      'city': provider.city,
      'uf': provider.uf,
    });
  }

  // void _selectDepartment(BuildContext context, Department department) {
  //   Navigator.of(context).pushNamed(
  //     AppRoutes.SECTORS,
  //     arguments: department,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fornecedores'),
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
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('providers')
              .orderBy('fantasyName')
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final documents = snapshot.data.documents;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, i) {
                // final Department department = Department(
                //   id: documents[i].id,
                //   name: documents[i]['name'],
                // );
                return Container(
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text(documents[i]['fantasyName']),
                      subtitle: Text(documents[i]['email']),
                      // trailing: Container(
                      //   width: 100,
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         icon: Icon(Icons.edit),
                      //         onPressed: () {},
                      //         color: Colors.orange,
                      //       ),
                      //       IconButton(
                      //         icon: Icon(Icons.delete),
                      //         color: Theme.of(context).errorColor,
                      //         onPressed: () => null,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // onTap: () => null,
                      // onTap: () => _selectDepartment(context, department),
                      // leading: Text('T'),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.delete),
                      //   color: Theme.of(context).errorColor,
                      //   onPressed: () {},
                      // ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _openProviderFormModal(context),
      ),
    );
  }
}
