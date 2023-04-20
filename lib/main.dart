import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invoice_intern/models/invoice_model.dart';
import 'package:invoice_intern/models/mini_invoice_model.dart';
import 'package:invoice_intern/provider/user_provider.dart';
import 'package:invoice_intern/screens/admin/add_invoice.dart';
import 'package:invoice_intern/screens/admin/admin_enter_page.dart';
import 'package:invoice_intern/screens/admin/admin_home_page.dart';
import 'package:invoice_intern/screens/admin/admin_view_invoice.dart';
import 'package:invoice_intern/screens/landing_page.dart';
import 'package:invoice_intern/screens/login_page.dart';
import 'package:invoice_intern/screens/register_page.dart';
import 'package:invoice_intern/screens/user/user_invoice_search.dart';
import 'package:invoice_intern/services/database.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart' as us;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        StreamProvider<List<us.User>>.value(
          value: Database().allusers,
          initialData: const [],
        ),
        StreamProvider<List<Invoice>>.value(
          value: Database().invoice,
          initialData: const [],
        ),
        StreamProvider<List<MiniInvoice>>.value(
          value: Database().miniinvoice,
          initialData: const [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            errorColor: Colors.white,
          ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const UserInvoiceSearch();
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Some Error Occurred',
                      ),
                    ),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const LandingPage();
            }),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/landing': (context) => const LandingPage(),
          '/admin': (context) => const AdminEnterPage(),
          '/admin/home': (context) => const AdminHomePage(),
          '/admin/add-invoice': (context) => const AddInvoice(),
          '/admin/view-invoice': (context) => const AdminViewInvoice(),
          // '/admin-invoice-detail': (context) => const AdminInvoiceDetail(),
          '/user/invoice-search': (context) => const UserInvoiceSearch(),
        },
      ),
    );
  }
}
