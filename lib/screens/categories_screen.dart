import 'package:requisition_app/components/category_form.dart';
import 'package:requisition_app/components/category_update_form.dart';
import 'package:requisition_app/models/category.dart';
import 'package:requisition_app/utils/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  _openCategoryFormModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CategoryForm(_addCategory);
      },
    );
  }

  Future<void> _addCategory(Category category) async {
    Navigator.of(context).pop();

    await FirebaseFirestore.instance.collection('categories').add({
      'name': category.name.toUpperCase(),
      'excluded': false,
    });
  }

  _openCategoryUpdateFormModal(context, category) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CategoryUpdateForm(_updateCategory, category);
      },
    );
  }

  Future<void> _updateCategory(Category category) async {
    Navigator.of(context).pop();

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.id)
        .update({
      'name': category.name.toUpperCase(),
    });
  }

  Future<void> _deleteCategory(Category category) async {
    Navigator.of(context).pop();

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.id)
        .update({'excluded': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .where('excluded', isEqualTo: false)
              .orderBy('name')
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
                final Category category = Category(
                  id: documents[i].id,
                  name: documents[i]['name'],
                  excluded: documents[i]['excluded'],
                );
                return Container(
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text(category.name),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _openCategoryUpdateFormModal(
                                  context, category),
                              color: Colors.orange,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirmação"),
                                        content: Text(
                                            "Você deseja excluir a Categoria ${category.name} ?"),
                                        actions: [
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          FlatButton(
                                            child: Text('Continuar'),
                                            onPressed: () =>
                                                _deleteCategory(category),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
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
        onPressed: () => _openCategoryFormModal(context),
      ),
    );
  }
}
