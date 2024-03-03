import 'package:flutter/material.dart';
import 'package:final_project/screens/category_screen.dart';

class safety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety and Security'),
      ),
     body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage( 'assets/images/noeye.png'), 
            
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Make the inner container transparent
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create a report',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 214, 30, 30),
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Full name';
                            }
                            if (value.length < 2) {
                              return "Username is too short.";
                            } else if (value.length > 16) {
                              return "Username is too long.";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Address',
                            hintText: 'Enter Address',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Report description',
                            hintText: 'Enter a description',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




