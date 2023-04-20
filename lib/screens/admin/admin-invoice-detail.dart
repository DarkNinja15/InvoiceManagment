// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_intern/models/mini_invoice_model.dart';
import 'package:invoice_intern/models/user_model.dart' as us;
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../widgets/mini-invoice-tile.dart';

// ignore: must_be_immutable
class AdminInvoiceDetail extends StatefulWidget {
  String title;
  String selectedValue;
  String invoiceId;
  String assignieUid;
  AdminInvoiceDetail({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.invoiceId,
    required this.assignieUid,
  }) : super(key: key);

  @override
  State<AdminInvoiceDetail> createState() => _AdminInvoiceDetailState();
}

class _AdminInvoiceDetailState extends State<AdminInvoiceDetail> {
  TextEditingController titleController = TextEditingController();
  final List<String> items = [
    'Status.open',
    'Status.complete',
    'Status.discarded',
    'Status.ongoing',
  ];
  List<us.User> users = [];
  List<MiniInvoice> miniInvoices = [];

  @override
  void didChangeDependencies() {
    users = Provider.of<List<us.User>>(context);
    miniInvoices = Provider.of<List<MiniInvoice>>(context)
        .where((element) => element.invoiceUid == widget.invoiceId)
        .toList();
    titleController.text = widget.title;
    if (kDebugMode) {
      print(miniInvoices);
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
          backgroundColor: Colors.transparent,
          title: Text(
            'Invoice Detail',
            style: savedStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Title',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: false,
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text(
                      'Change Status',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 30),
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
                          value: widget.selectedValue,
                          onChanged: (value) {
                            setState(() {
                              widget.selectedValue = value as String;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: double.infinity * 0.5,
                            padding: const EdgeInsets.only(left: 14, right: 14),
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
                              thickness: MaterialStateProperty.all<double>(6),
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
                const SizedBox(height: 25),
                Text(
                  'Assigned to ${(users.firstWhere((element) => element.uid == widget.assignieUid).name)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Mini Invoices',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: miniInvoices.length,
                    itemBuilder: (context, index) {
                      String assignieName = users
                          .firstWhere((element) =>
                              element.uid == miniInvoices[index].assignieUid)
                          .name;
                      Status? status;
                      return GestureDetector(
                        onTap: () {
                          dialog(context, miniInvoices[index].miniInvoiceUid);
                        },
                        child: miniCard(
                          miniInvoices[index].title,
                          assignieName,
                          status ?? miniInvoices[index].status,
                        ),
                      );
                    }),
                const SizedBox(height: 75),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('invoices')
                .doc(widget.invoiceId)
                .update({
              'status': widget.selectedValue,
            }).then((value) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/admin/home', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoice updated successfully')));
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating invoice: $error')));
            });
          },
          label: const Text('Save'),
          backgroundColor: pinkColor1,
        ),
      ),
    );
  }

  void dialog(BuildContext ctx, String miniInvoiceId) {
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
                            print(miniInvoiceId);
                          }
                          await FirebaseFirestore.instance
                              .collection('miniinvoices')
                              .doc(miniInvoiceId)
                              .update({
                            'status': dialogSelected,
                          }).then((value) {
                            Navigator.of(context).pop();
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Error updating mini-invoice: $error')));
                          });
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
