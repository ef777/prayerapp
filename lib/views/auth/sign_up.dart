import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../widgets/custom_button.dart';
import '../service/auth_service.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password, name;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      appBar: AppBar(
          centerTitle: false,
          title: Text("Kayıt Ol"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios))),
      body: appBody(height),
    );
  }

  SingleChildScrollView appBody(double height) {
    return SingleChildScrollView(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: context.horizontalPaddingLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customSizedBox(),
                      Text(
                        "Kayıt Olarak Daha İyi Bir Deneyime Sahip Olabilirsiniz",
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      customSizedBox(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                  color: Colors.grey.withOpacity(.4))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            textfiledTitle("İsim"),
                            nameTextField(),
                            SizedBox(
                              height: context.height * 0.01,
                            ),
                            textfiledTitle("Mail"),
                            emailTextField(),
                            SizedBox(
                              height: context.height * 0.01,
                            ),
                            textfiledTitle("Şifre"),
                            passwordTextField(),
                            SizedBox(
                              height: context.height * 0.01,
                            ),
                            textfiledTitle("Şifre Tekrarı"),
                            passwordTextField(),
                            customSizedBox(),
                            CustomButton(
                              title: "Kayıt Ol",
                              onPressed: signIn,
                              color: Color.fromRGBO(27, 41, 86, 1),
                            ),
                          ],
                        ),
                      ),

                      // CustomTextButton(
                      //   onPressed: () =>
                      //       Navigator.pushNamed(context, "/signUp"),
                      //   buttonText: "Hesap Olustur",
                      // ),,

                      customSizedBox(),
                      RichText(
                        text: TextSpan(
                          text: 'Bir hesaba mı sahipsin ?  ',
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: 'Giriş Yap',
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Düğme tıklandığında yapılacak işlemler
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding textfiledTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: context.textTheme.titleMedium
              ?.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
      decoration: customInputDecoration("Mailinizi giriniz"),
    );
  }

  TextFormField nameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
        return null;
      },
      onSaved: (value) {
        name = value!;
      },
      decoration: customInputDecoration("İsminizi giriniz"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      decoration: customInputDecoration("Şifrenizi giriniz"),
    );
  }

  Center signInButton() {
    return Center(
      child: TextButton(
        onPressed: signIn,
        child: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff31274F)),
          child: Center(
            child: customText("Giris Yap", Colors.blue),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        final userResult = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
        print(userResult.user!.email);
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/signUp"),
        child: customText("Hesap Olustur", Colors.blue),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 30,
      );

  Widget customText(String text, Color color) => Text(
        text,
        style: TextStyle(color: color),
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.only(top: 2, left: 12),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
