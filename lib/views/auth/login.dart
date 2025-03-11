import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/auth_repo.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:farmers_touch/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<UserProvider>(context);

    return Container(
      height: height,
      width: width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(
      //       "https://img.freepik.com/premium-photo/view-sa-dec-flower-garden-dong-thap-province-vietnam-its-famous-mekong-delta-preparing-transport-flowers-market-sale-tet-holiday_991182-14414.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
      //     ),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtil.primaryColor,
          title: Text(
            "Farmers Touch",
            style: theme.textTheme.titleLarge,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Reusable.customField("Email", email),
                SizedBox(
                  height: 20,
                ),
                Reusable.customField("Password", password),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Doesn't have an account?  ",
                      style: theme.textTheme.displayMedium!.copyWith(
                        color: ColorsUtil.txtColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: theme.textTheme.displayMedium!
                            .copyWith(color: ColorsUtil.primaryColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                (!isLoading)
                    ? Container(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsUtil.primaryColor,
                          ),
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final data = await AuthRepo().login(
                                  email.text.trim(), password.text.trim());
                              setState(() {
                                isLoading = false;
                              });
                              if (data != null) {
                                // debugPrint("")
                                await provider.setUser(data.user!);
                                debugPrint("data: " + data.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              } else {
                                debugPrint("error");
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      )
                    : CircularProgressIndicator(
                        color: ColorsUtil.primaryColor,
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
