import 'package:flutter/material.dart';

import '../widget/backarrow_nav.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _issueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phoneController.dispose();
    _issueController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initial Selected Value
    String dropdownvalue = 'Issue Regarding Transcations';

    // List of items in our dropdown menu
    var items = [
      'Issue Regarding Transcations',
      'Issue Regarding Result',
      'Feedback',
      'Review',
      'Others',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(230, 239, 250, 1),
        leading: const BackArrowNav(),
        elevation: 0,
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(230, 239, 250, 1),
        ),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      controller: _phoneController,
                      enabled: true,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
