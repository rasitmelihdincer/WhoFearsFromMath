import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/models/quiz_paper_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/screens/screens.dart'
    show AppIntroductionScreen, HomeScreen, LoginScreen, QuizeScreen;
import 'package:flutter_application_2/utils/utils.dart';
import 'package:flutter_application_2/widgets/widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var country = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;
  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // waiting in splash
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      _user.value = user;
    });
    navigateToIntroduction();
  }

  void clearTextFields() {
    emailController.clear();
    passwordController.clear();

    nameController.clear();
  }

  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Firestore'daki kullanıcı verilerini sil
        await deleteUserFirestoreData(user.email.toString());
        // Authentication'dan kullanıcıyı sil
        await user.delete();
        // Başarılı silme işlemi sonrası kullanıcıyı ana ekrana yönlendir
        navigateToIntroduction();
        Get.snackbar('Success', 'Your account has been successfully deleted.');
      } catch (e) {
        // Hata mesajı göster
        Get.snackbar('Error', 'An error occurred while deleting the account.');
        print(e.toString());
      }
    }
  }

  Future<void> deleteUserFirestoreData(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      // Firestore'dan veri başarıyla silindi
    } catch (e) {
      // Veri silinirken bir hata oluştu, hata yönetimi
      throw Exception('Failed to delete user data from Firestore.');
    }
  }

  Future<void> registerWithEmailPassword() async {
    if (email.value.isEmpty || password.value.isEmpty || name.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields before registering.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (email.value.isEmpty || password.value.isEmpty) {
      // Email veya şifre boş ise hata mesajı göster
      Get.snackbar('Error', 'Email and password cannot be left blank.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.value, password: password.value);

      if (userCredential.user != null) {
        await userCredential.user!.updateProfile(displayName: name.value);
        await saveUserWithEmail(userCredential.user);

        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred, please try again';
      // Firebase hata kodlarına göre özel hata mesajları
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'The e-mail address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid e-mail address.';
          break;
        // Daha fazla hata durumu için case eklenebilir...
      }
      Get.snackbar('Registration Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Diğer türdeki hatalar için genel bir hata mesajı
      Get.snackbar('Error', 'An error occurred, please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveUserWithEmail(User? user) async {
    if (user != null) {
      userFR.doc(user.email).set({
        "email": user.email,
        "name": name.value,
        //    "country": country.value,
      });
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value, password: password.value);
      if (userCredential.user != null) {
        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user was found with this e-mail address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password, please try again.';
          break;
        // ... diğer hata kodları için mesajlar ...
        default:
          errorMessage = 'An error occurred, please try again.';
      }
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM); // Hata mesajını göster
    }
  }

  Future<void> siginInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final gAuthentication = await account.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: gAuthentication.idToken,
            accessToken: gAuthentication.accessToken);
        await _auth.signInWithCredential(credential);
        await saveUser(account);
        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e); // Hata ayrıntılarını logla
      print("FirebaseAuthException: ${e.message}");
      print("ssss");
    }
  }

  Future<void> signInWithApple() async {
    try {
      // Apple ile giriş işlemi başlatılıyor
      final AuthorizationCredentialAppleID appleIdCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final OAuthCredential credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      // Firebase'e Apple credential ile giriş yapılıyor
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Eğer kullanıcı yeni ise veya displayName null ise, ad ve e-posta bilgilerini kaydet
      if (userCredential.additionalUserInfo!.isNewUser ||
          userCredential.user!.displayName == null) {
        String displayName = 'Apple User'; // Varsayılan isim
        if (appleIdCredential.givenName != null) {
          displayName = [
            appleIdCredential.givenName!,
            appleIdCredential.givenName,
          ].where((s) => s != null && s.isNotEmpty).join(' ');
        }

        // Firebase'de kullanıcı profilini güncelle
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateProfile(displayName: displayName);
          await userCredential.user!.reload();
          _user.value = _auth.currentUser; // Kullanıcı bilgisini güncelle
        }

        // Firebase veritabanında kullanıcı bilgilerini kaydet
        await saveUserWithEmail(userCredential.user);
      }

      navigateToHome();
    } catch (e) {
      // Hata işleme
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    AppLogger.d("Sign out");
    try {
      await _auth.signOut();
      // Kullanıcı bilgilerini temizle
      email.value = '';
      password.value = '';
      name.value = '';

      // TextEditingController'ları temizle
      emailController.clear();
      passwordController.clear();

      nameController.clear();

      // Kullanıcıyı giriş ekranına yönlendir
      navigateToHome();
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
    }
  }

  Future<void> saveUser(GoogleSignInAccount account) async {
    userFR.doc(account.email).set({
      "email": account.email,
      "name": account.displayName,
      "profilepic": account.photoUrl
    });
  }

  User? getUser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }

  bool isLogedIn() {
    return _auth.currentUser != null;
  }

  void navigateToHome() {
    Get.offAllNamed(AppIntroductionScreen.routeName);
    emailController.clear();
    passwordController.clear();

    nameController.clear();
  }

  void navigateToLogin() {
    Get.toNamed(LoginScreen.routeName);
  }

  void navigateToIntroduction() {
    Get.offAllNamed(AppIntroductionScreen.routeName);
  }

  void showLoginAlertDialog({required Function onContinueWithoutLogin}) {
    Get.dialog(
      Dialogs.quizStartDialog(
        onTap: () {
          Get.back();
          navigateToLogin();
        },
        onTap2: () {
          Get.back();
          onContinueWithoutLogin();
        },
      ),
      barrierDismissible: false,
    );
  }
}
