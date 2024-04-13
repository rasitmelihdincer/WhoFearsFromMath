import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_icons_icons.dart';
import 'package:flutter_application_2/configs/themes/custom_text_styles.dart';
import 'package:flutter_application_2/configs/themes/ui_parameters.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/controllers/common/drawer_controller.dart';
import 'package:flutter_application_2/game/gameScreen.dart';
import 'package:flutter_application_2/screens/screens.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/common/circle_button.dart';

class AppIntroductionScreen extends GetView<MyDrawerController> {
  const AppIntroductionScreen({super.key});
  static const String routeName = '/introduction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        borderRadius: 50.0,
        showShadow: true,
        angle: 0.0,
        style: DrawerStyle.defaultStyle,
        menuScreen: const CustomDrawer(),
        menuBackgroundColor: Colors.white.withOpacity(0.5),
        slideWidth: MediaQuery.of(context).size.width * 0.6,
        mainScreen: Container(
          decoration: BoxDecoration(gradient: mainGradient(context)),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kMobileScreenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(-10, 0),
                        child: CircularButton(
                          onTap: controller.toggleDrawer,
                          child: const Icon(AppIcons.menuleft),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Builder(
                              builder: (_) {
                                final AuthController auth = Get.find();
                                final user = auth.getUser();
                                String label = '  Hello mate';
                                if (user != null) {
                                  label = '  Hello ${user.displayName}';
                                }
                                return Text(label,
                                    style: kDetailsTS.copyWith(
                                        color: kOnSurfaceTextColor));
                              },
                            ),
                          ],
                        ),
                      ),
                      const Text('Welcome \nWho Fears From Math',
                          style: kHeaderTS),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 60), // Sağdan ve soldan boşluk
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // İçerikleri dikey olarak ortala
                    children: [
                      SizedBox(
                        width: double
                            .infinity, // Butonun ekran genişliğine uymasını sağlar
                        child: ElevatedButton(
                          onPressed: () {
                            // Birinci butonun yapacağı işlem
                            Get.toNamed(HomeScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ), // Butonun içerik rengi (yazı, ikon vs.)
                          ),
                          child: const Text(
                            'Dyscalculia Test',
                            style: kHeaderTS,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Butonlar arası dikey boşluk
                      SizedBox(
                        width: double
                            .infinity, // Butonun ekran genişliğine uymasını sağlar
                        child: ElevatedButton(
                          onPressed: () {
                            // Get.to(ColorGame());
                            Get.to(const GameScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ), // Butonun içerik rengi (yazı, ikon vs.)
                          ),
                          child: Text(
                            'Math Games',
                            style: kHeaderTS,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Butonlar arası dikey boşluk

                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('visibility')
                            .doc('visible')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Veri yüklenirken gösterilecek widget
                          } else if (snapshot.hasError) {
                            print(snapshot
                                .error); // Hata detaylarını konsola yazdır
                            return Text('Something Went Wrong.');
                          } else if (snapshot.hasData &&
                              snapshot.data!.exists) {
                            bool isVisible = snapshot
                                .data!['visible']; // 'visible' alanını oku
                            String buttonName = snapshot.data!['buttonName'] ??
                                'Default Button Text'; // 'buttonName' alanını oku, eğer yoksa varsayılan bir metin kullan
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isVisible
                                    ? () {
                                        Get.toNamed(Home2Screen
                                            .routeName); // İkinci butonun yapacağı işlem
                                      }
                                    : null, // isVisible false ise butonu devre dışı bırak
                                child: Text(
                                  buttonName, // Firestore'dan okunan buton metni
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: kOnSurfaceTextColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Text('Veri bulunamadı');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

 
/*
void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Language'),
        content: Container(
          width: double.minPositive,
          height: 200, // Listeyi sınırlı bir yükseklikte tutmak için
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text('🇬🇧   English'),
                onTap: () {
                  Get.updateLocale(Locale('en', 'US'));
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
              ),
              ListTile(
                title: Text('🇹🇷   Türkçe'),
                onTap: () {
                  Get.updateLocale(Locale('tr', 'TR'));
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
              ),
              ListTile(
                title: Text('🇪🇸   Español'),
                onTap: () {
                  Get.updateLocale(Locale('es', 'ES'));
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
*/
