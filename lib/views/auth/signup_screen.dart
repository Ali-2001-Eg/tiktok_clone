import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:tiktok_clone/views/auth/login_screen.dart';

import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                'Tiktok clone',
                style: TextStyle(
                    fontSize: 35,
                    color: buttonColor,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 25,
              ),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'Sign up now to discover our media and to have your own world!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GetBuilder<AuthController>(
                builder: (context) {
                  return Stack(
                    children: [
                      ClipOval(
                        child: (Get.find<AuthController>().pickedImage != null)
                            ? Image(
                                image: FileImage(
                                    Get.find<AuthController>().pickedImage!),
                                height: 300,
                                width: 300,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                                height: 300,
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 13,
                        child: Container(
                          // padding: EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: buttonColor,
                              size: 25,
                            ),
                            onPressed: () {
                              authController.pickImage();
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }
              ),
              const SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 0),
                child: CustomTextInputField(
                  controller: nameController,
                  icon: Icons.person,
                  labelText: 'username',
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 0),
                child: CustomTextInputField(
                  controller: emailController,
                  icon: Icons.email,
                  labelText: 'Email Address',
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: screenSize(context).width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 0),
                child: CustomTextInputField(
                  controller: passwordController,
                  icon: Icons.lock,
                  labelText: 'Password',
                  isObscure: true,
                ),
              ),
              const SizedBox(height: 25),
              //button
              GetBuilder<AuthController>(
                builder: (controller) => controller.isLoading
                    ? const CustomIndicator()
                    : Container(
                        width: screenSize(context).width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: InkWell(
                          onTap: () {
                            controller.register(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                authController.pickedImage);
                          },
                          child: const Center(
                              child: Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          )),
                        ),
                      ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account ? ',
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: buttonColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
