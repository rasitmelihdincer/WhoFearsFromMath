import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';

class CustomDrawer extends GetView<MyDrawerController> {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(gradient: mainGradient(context)),
      padding: UIParameters.screenPadding,
      child: Theme(
        data: ThemeData(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: kOnSurfaceTextColor))),
        child: SafeArea(
            child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              child: BackButton(
                color: kOnSurfaceTextColor,
                onPressed: () {
                  controller.toggleDrawer();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Obx(() => controller.user.value == null
                      ? TextButton.icon(
                          icon: const Icon(Icons.login_rounded),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              elevation: 0,
                              backgroundColor: Colors.white.withOpacity(0.5)),
                          onPressed: () {
                            controller.signIn();
                          },
                          label: const Text("Sign in"))
                      : GestureDetector(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 10),
                              child: CircleAvatar(
                                foregroundImage:
                                    controller.user.value!.photoURL == null
                                        ? AssetImage("assets/logo-png.png")
                                            as ImageProvider
                                        : NetworkImage(
                                            controller.user.value!.photoURL!),
                                backgroundColor: Colors.white,
                                radius: 40,
                              ),
                            ),
                          ),
                        )),
                  Obx(
                    () => controller.user.value == null
                        ? const SizedBox()
                        : Text(controller.user.value!.displayName ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: kOnSurfaceTextColor)),
                  ),
                  const Spacer(flex: 8),
                  Obx(
                    () => controller.user.value == null
                        ? const SizedBox()
                        : _DrawerButton(
                            icon: Icons.delete,
                            label: 'Delete Account',
                            onPressed: () async {
                              // Kullanıcıdan hesabı silmek isteyip istemediğini onaylamasını isteyin
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Account'),
                                  content: Text(
                                      'Are you sure you want to delete your account? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              // Kullanıcı hesabı silmek için onay verirse, silme işlevini çağır
                              if (shouldDelete == true) {
                                controller.deleteUser();
                              }
                            },
                          ),
                  ),
                  _DrawerButton(
                    icon: AppIcons.logout,
                    label: 'Sign out',
                    onPressed: () {
                      controller.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 15,
        ),
        label: Align(alignment: Alignment.centerLeft, child: Text(label)));
  }
}
