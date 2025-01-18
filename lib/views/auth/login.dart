import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:farmers_touch/views/auth/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Reusable.customField("Email"),
              SizedBox(
                height: 20,
              ),
              Reusable.customField("Password"),
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
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsUtil.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
