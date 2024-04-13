import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/screens/auth_and_profile/sign_in_screen.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Log In "),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: SingleChildScrollView(
          // Kaydırılabilir yap
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Üstte boşluk
              SizedBox(height: 60),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  labelStyle: TextStyle(
                      color: Colors.white), // Etiket metnini özelleştir
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email,
                      color: Colors.white), // İkon rengini özelleştir
                ),
                onChanged: (value) => controller.email.value = value,
              ),
              SizedBox(height: 20), // Alanlar arası boşluk
              TextFormField(
                controller: controller.passwordController,
                onChanged: (value) => controller.password.value = value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30), // Buton öncesi boşluk
              MainButton(
                onTap: () => controller.signInWithEmailAndPassword(),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10), // İkon ve metin arası boşluk
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60), // Butonlar arası boşluk

              MainButton(
                onTap: () => controller.siginInWithGoogle(),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/google.svg',
                      height: 24, // İkon boyutunu ayarla
                      width: 24,
                    ),
                    SizedBox(width: 10), // İkon ve metin arası boşluk
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              MainButton(
                onTap: () => controller.signInWithApple(),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/applelogo.svg',
                      height: 24, // İkon boyutunu ayarla
                      width: 24,
                    ),
                    SizedBox(width: 10), // İkon ve metin arası boşluk
                    Text(
                      'Sign in with Apple',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16), // Burada metin stilini ayarlayabilirsiniz
                  children: <TextSpan>[
                    TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                          color: Colors
                              .black), // Burada bağlantı stilini ayarlayabilirsiniz
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offAndToNamed(SignInScreen.routeName);
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
