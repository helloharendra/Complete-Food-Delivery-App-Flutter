import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rider_app/widgets/custom_text_field.dart';
import 'package:rider_app/widgets/error_Dialog.dart';
import 'package:rider_app/widgets/loading_dialog.dart';
import 'package:rider_app/mainScreens/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmePasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";

  String completeAddress = "";

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب عنوانك يدويًا أو اسمح بالوصول للموقع من إعدادات الهاتف')));
      }
      return;
    }
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMarks = placeMarks![0];
    completeAddress =
        '${pMarks.subThoroughfare} ${pMarks.thoroughfare},${pMarks.subLocality} ${pMarks.locality},${pMarks.subAdministrativeArea}, ${pMarks.administrativeArea} ${pMarks.postalCode},${pMarks.country}';
    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
      if (passwordController.text == confirmePasswordController.text) {
        if (confirmePasswordController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty &&
            emailController.text.isNotEmpty) {
// start uploading the data
          showDialog(
              context: context,
              builder: (context) {
                return const LoadingDialog(
                  message: "جاري إنشاء حساب المندوب...",
                );
              });
          // Rider registration must not depend on Firebase Storage. A profile
          // image can be added later when the shared HTTPS upload service is
          // available; the operational account remains usable without one.
          sellerImageUrl = '';
          authenticateSellerAndSignUp();
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                    message: "أكمل بيانات التسجيل المطلوبة");
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(message: "كلمتا المرور غير متطابقتين");
            });
      }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute =
            MaterialPageRoute(builder: (context) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    await FirebaseFirestore.instance.collection('riders').doc(currentUser.uid).set({
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameController.text.trim(),
      "riderAvtar": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": locationController.text.trim(),
      "status": MerchantStatus.pending.name,
      "cityId": LaunchLocationDefaults.cityId,
      "available": false,
      "serviceZoneIds": <String>[],
      "lat": position?.latitude ?? 0,
      "lng": position?.longitude ?? 0,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    // save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("PhotoUrl", sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            const CircleAvatar(
              radius: 52,
              backgroundColor: Color(0xFFE8F5EC),
              child: Icon(Icons.delivery_dining_rounded, size: 54, color: Color(0xFF166534)),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: 'الاسم',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: 'البريد الإلكتروني',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: 'كلمة المرور',
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmePasswordController,
                    hintText: 'تأكيد كلمة المرور',
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: 'رقم الهاتف',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: 'العنوان أو الموقع الحالي',
                    isObsecre: false,
                    enabled: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //  print(completeAddress.toString());
                        setState(() {
                          getCurrentLocation();
                        });
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'تحديد موقعي الحالي',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 249, 168, 87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => {
                formValidation(),
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              child: const Text(
                "إرسال طلب الانضمام",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
