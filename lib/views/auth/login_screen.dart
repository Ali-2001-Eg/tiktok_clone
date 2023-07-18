import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:tiktok_clone/shared/widgets/custom_text_input_field.dart';
import 'package:tiktok_clone/views/auth/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(Get.find<AuthController>().isLoading);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
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
                    'Login now to discover our media and to have your own world!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
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
                builder: (controller) {
                  return controller.isLoading
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
                              controller.userLogin(emailController.text.trim(),
                                  passwordController.text.trim());
                            },
                            child: const Center(
                                child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            )),
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => SignupScreen());
                    },
                    child: Text(
                      'Register',
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
