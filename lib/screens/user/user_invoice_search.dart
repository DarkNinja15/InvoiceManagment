import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_intern/models/invoice_model.dart';
import 'package:invoice_intern/models/mini_invoice_model.dart';
import 'package:invoice_intern/services/auth_methods.dart';
import 'package:invoice_intern/widgets/mini-invoice-tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../models/user_model.dart' as us;
import 'package:awesome_dialog/awesome_dialog.dart';

class UserInvoiceSearch extends StatefulWidget {
  const UserInvoiceSearch({Key? key}) : super(key: key);

  @override
  State<UserInvoiceSearch> createState() => _UserInvoiceSearchState();
}

class _UserInvoiceSearchState extends State<UserInvoiceSearch> {
  List<Invoice> allInvoices = [];
  List<Invoice> invoices = [];
  List<MiniInvoice> allMiniInvoices = [];
  List<us.User> users = [];
  List<String> items = [
    'Status.complete',
    'Status.discarded',
    'Status.ongoing',
    'Status.open',
  ];
  String name = '';

  @override
  void initState() {
    addData();
    super.initState();
  }

  void addData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      sharedPreferences.setString('name', value['name']);
    });
    name = (sharedPreferences.getString('name'))!;
    if (kDebugMode) {
      print(name);
    }
  }

  @override
  void didChangeDependencies() {
    invoices = Provider.of<List<Invoice>>(context);
    allInvoices = invoices
        .where(
          (element) =>
              element.assignieUid == FirebaseAuth.instance.currentUser!.uid,
        )
        .toList();
    allMiniInvoices = Provider.of<List<MiniInvoice>>(context)
        .where((element) =>
            element.assignieUid == FirebaseAuth.instance.currentUser!.uid)
        .toList();
    users = Provider.of<List<us.User>>(context);
    if (kDebugMode) {
      print(allInvoices);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pinkColor2, pinkColor1],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                AwesomeDialog(
                  btnCancelOnPress: () {},
                  btnCancelColor: Colors.grey,
                  btnOkColor: Colors.white,
                  animType: AnimType.leftSlide,
                  dialogBackgroundColor: pinkColor1,
                  title: 'Logout',
                  titleTextStyle: savedStyle,
                  desc: 'Are you sure you want to logout?',
                  dialogType: DialogType.question,
                  buttonsTextStyle: savedStyle.copyWith(color: pinkColor1),
                  btnOkOnPress: () async {
                    await AuthMethods().logout().then((value) {
                      if (value) {
                        Navigator.pushReplacementNamed(context, '/landing');
                      }
                    });
                  },
                  context: context,
                ).show();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'All Invoices',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AnimatedTextKit(animatedTexts: [
                  TyperAnimatedText(
                    'Welcome user',
                    textStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Your Assigned Invoices',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  Invoices',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allInvoices.length,
                    itemBuilder: (context, index) {
                      String assignieName = users
                          .firstWhere((element) =>
                              element.uid == allInvoices[index].assignieUid)
                          .name;
                      return GestureDetector(
                        onTap: () {
                          dialog(
                            context,
                            allInvoices[index].invoiceuid,
                            true,
                          );
                        },
                        child: miniCard(
                          allInvoices[index].title,
                          assignieName,
                          allInvoices[index].status,
                        ),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  Mini Invoices',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allMiniInvoices.length,
                    itemBuilder: (context, index) {
                      String assignieName = users
                          .firstWhere((element) =>
                              element.uid == allMiniInvoices[index].assignieUid)
                          .name;
                      String invoiceName = invoices
                          .firstWhere((element) =>
                              element.invoiceuid ==
                              allMiniInvoices[index].invoiceUid)
                          .title;
                      return GestureDetector(
                        onTap: () {
                          dialog(
                            context,
                            allMiniInvoices[index].miniInvoiceUid,
                            false,
                          );
                        },
                        child: miniCard(
                          '${allMiniInvoices[index].title} ($invoiceName)',
                          assignieName,
                          allMiniInvoices[index].status,
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dialog(BuildContext ctx, String id, bool isInvoice) {
    String? dialogSelected;
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setstatealert) {
              return Dialog(
                backgroundColor: pinkColor1,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0)), //this right here
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 150.0,
                  width: 350.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(18, 7, 0, 7),
                            child: const Text(
                              ' Status',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: dialogSelected,
                                onChanged: (value) {
                                  setstatealert(() {
                                    dialogSelected = value as String;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity * 0.5,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: pinkColor1,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.white,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: pinkColor1,
                                  ),
                                  elevation: 8,
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        MaterialStateProperty.all<double>(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: const Center(
                              child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: () async {
                          if (kDebugMode) {
                            print(id);
                          }
                          if (isInvoice) {
                            await FirebaseFirestore.instance
                                .collection('invoices')
                                .doc(id)
                                .update({
                              'status': dialogSelected,
                            }).then((value) {
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Error updating mini-invoice: $error')));
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('miniinvoices')
                                .doc(id)
                                .update({
                              'status': dialogSelected,
                            }).then((value) {
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Error updating mini-invoice: $error')));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }
}
