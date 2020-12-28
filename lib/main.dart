import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:requisition_app/screens/auth_screen.dart';
import 'package:requisition_app/screens/requisition_form_screen.dart';
import 'package:requisition_app/screens/departments_screen.dart';
import 'package:requisition_app/screens/details_requisition_screen.dart';
import 'package:requisition_app/screens/details_user_screen.dart';
import 'package:requisition_app/screens/home_screen.dart';
import 'package:requisition_app/screens/providers_screen.dart';
import 'package:requisition_app/screens/requisitions_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:requisition_app/screens/sectors_screen.dart';
import 'package:requisition_app/screens/users_screen.dart';
import 'package:requisition_app/utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
      routes: {
        // AppRoutes.HOME: (ctx) => HomeScreen(),
        AppRoutes.REQUISITIONS: (ctx) => RequisitionsScreen(),
        AppRoutes.REQUISITION_FORM_SCREEN: (ctx) => RequisitionFormScreen(),
        // AppRoutes.CREATE_REQUISITION_P2: (ctx) => CreateRequisitionP2(),
        // AppRoutes.CREATE_REQUISITION_P3: (ctx) => CreateRequisitionP3(),
        AppRoutes.DEPARTMENTS: (ctx) => DepartmentsScreen(),
        AppRoutes.SECTORS: (ctx) => SectorsScreen(),
        AppRoutes.PROVIDERS: (ctx) => ProvidersScreen(),
        AppRoutes.USERS: (ctx) => UserScreen(),
        AppRoutes.USER_DETAILS: (ctx) => UserDetailsScreen(),
        AppRoutes.REQUISITION_DETAILS: (ctx) => RequisitionDetailsScreen(),
      },
    );
  }
}
