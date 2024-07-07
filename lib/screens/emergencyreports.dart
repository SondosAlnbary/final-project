import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  String selectedCollection = 'Utilities';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Emergency Report List',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/noeye.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(selectedCollection)
                        .where('Emergency', isEqualTo: 'yes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No emergency reports available.',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      final reports = snapshot.data!.docs.reversed.toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          var report = reports[index];
                          return ReportItem(
                            report: report,
                            selectedCollection: selectedCollection,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> doesCollectionExist(String collectionName) async {
    var collectionRef = FirebaseFirestore.instance.collection(collectionName);
    var docSnapshot = await collectionRef.limit(1).get();
    return docSnapshot.docs.isNotEmpty;
  }
}

class ReportItem extends StatefulWidget {
  final QueryDocumentSnapshot report;
  final String selectedCollection;

  ReportItem({required this.report, required this.selectedCollection});

  @override
  _ReportItemState createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.report['situation'];
  }

  void _updateSituation(String? value) async {
    if (value != null) {
      setState(() {
        _selectedValue = value;
      });

      await FirebaseFirestore.instance
          .collection(widget.selectedCollection)
          .doc(widget.report.id)
          .update({'situation': value});
    }
  }

  void _deleteReport() async {
    await FirebaseFirestore.instance
        .collection(widget.selectedCollection)
        .doc(widget.report.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.report['sender'],
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.report['address'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.selectedCollection,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        widget.report['Report'],
                        style: TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteReport();
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'Not yet treated',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('Not yet treated'),
                  Radio<String>(
                    value: 'In treatment',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('In treatment'),
                  Radio<String>(
                    value: 'Done',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('Done'),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
