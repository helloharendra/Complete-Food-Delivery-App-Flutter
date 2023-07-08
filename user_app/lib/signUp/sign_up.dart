import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const signUp());
}

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

// ignore: camel_case_types
class _signUpState extends State<signUp> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/login.png',
                  height: 200,
                  width: 200,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.face),
                      hintText: 'Enter your Full Name',
                      labelText: 'Full Name'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.date_range),
                      hintText: 'Enter your DOB',
                      labelText: 'DOB'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: 'Enter your Contact',
                      labelText: 'Mobile no.'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.streetview),
                      hintText: 'Enter your Address',
                      labelText: 'Address'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Enter your Email',
                      labelText: 'E-mail'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      hintText: 'Enter your Password',
                      labelText: 'Password'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const signUp()));
                        },
                        child: const ElevatedButton(
                          onPressed: null,
                          child: Text('Sign up'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const login()));
                        },
                        child: const ElevatedButton(
                          onPressed: null,
                          child: Text(
                            'Sign in',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
