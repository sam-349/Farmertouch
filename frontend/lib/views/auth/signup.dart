import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsUtil.onPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Farmers Touch",
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 5,
              ),
              Reusable.customField("Email"),
              SizedBox(
                height: 20,
              ),
              Reusable.customField("password"),
              SizedBox(
                height: 20,
              ),
              Reusable.customField("Confirm Password"),
              SizedBox(
                height: 20,
              ),
              //Dropdown for category to choose farmer or customer
              DropdownMenu(
                menuStyle: MenuStyle(
                  // maximumSize: MaterialStateProperty.all(Size(300, 300)),
                  backgroundColor:
                      MaterialStateProperty.all(ColorsUtil.onPrimary),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: ColorsUtil.bgColor,
                  filled: true,
                ),
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                width: width - 40,
                label: Text("Choose category"),
                dropdownMenuEntries: ["Farmer", "Customer"].map((item) {
                  return DropdownMenuEntry(value: item, label: item);
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?  ",
                    style: theme.textTheme.displayMedium!.copyWith(
                      color: ColorsUtil.txtColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: theme.textTheme.displayMedium!.copyWith(
                        color: ColorsUtil.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                // width: 100,
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
                    "Sign Up",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
