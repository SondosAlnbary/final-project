import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report List'),
      ),
      body: Container(
        color: Colors.blueGrey[100], // Set the background color here
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Sanitation').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
              return Center(child: Text('No reports available.'));
            }

            final sanitationReports = snapshot.data!.docs.reversed.toList();

            return ListView.builder(
              itemCount: sanitationReports.length,
              itemBuilder: (context, index) {
                var sanit = sanitationReports[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(sanit['sender']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sanit['adress']),
                          Text('Sanitation', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Text(sanit['Report']),
                    ),
                    Divider(),
                  ],
                );
              },
            );
          },
        ),
        // child: StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance.collection('environment').snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     }

        //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
        //       return Center(child: Text('No reports available.'));
        //     }

        //     final sanitationReports = snapshot.data!.docs.reversed.toList();

        //     return ListView.builder(
        //       itemCount: sanitationReports.length,
        //       itemBuilder: (context, index) {
        //         var sanit = sanitationReports[index];
        //         return Column(
        //           children: [
        //             ListTile(
        //               title: Text(sanit['sender']),
        //               subtitle: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(sanit['adress']),
        //                   Text('Enviroment', style: TextStyle(fontWeight: FontWeight.bold)),
        //                 ],
        //               ),
        //               trailing: Text(sanit['Report']),
        //             ),
        //             Divider(),
        //           ],
        //         );
        //       },
        //     );
        //   },
        // ),
      ),

    );
  }
}
