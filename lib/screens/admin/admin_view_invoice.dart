import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_intern/models/invoice_model.dart';
import 'package:invoice_intern/screens/admin/admin-invoice-detail.dart';
import 'package:invoice_intern/widgets/mini-invoice-tile.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart' as us;
import '../../constants/constants.dart';

class AdminViewInvoice extends StatefulWidget {
  const AdminViewInvoice({Key? key}) : super(key: key);

  @override
  State<AdminViewInvoice> createState() => _AdminViewInvoiceState();
}

class _AdminViewInvoiceState extends State<AdminViewInvoice> {
  List<Invoice> allInvoices = [];
  List<us.User> users = [];

  @override
  void didChangeDependencies() {
    users = Provider.of<List<us.User>>(context);
    allInvoices = Provider.of<List<Invoice>>(context);
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
          backgroundColor: Colors.transparent,
          title: Text('View Invoice', style: savedStyle),
        ),
        body: ListView.builder(
          itemCount: allInvoices.length,
          itemBuilder: (context, index) {
            String assignieName = users
                .firstWhere(
                    (element) => element.uid == allInvoices[index].assignieUid)
                .name;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminInvoiceDetail(
                                assignieUid: allInvoices[index].assignieUid,
                                invoiceId: allInvoices[index].invoiceuid,
                                selectedValue:
                                    allInvoices[index].status.toString(),
                                title: allInvoices[index].title,
                              )));
                },
                child: miniCard(
                  allInvoices[index].title,
                  assignieName,
                  allInvoices[index].status,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
