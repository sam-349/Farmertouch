import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';
// import 'reusable.dart'; // Import your reusable class

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // User data
  String name = "Samuel";
  String phone = "7569378795";
  String email = "example@gmail.com";
  String state = "Andhra Pradesh";

  // For editing mode
  bool isEditing = false;

  // Controllers for editing
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedState;

  final List<String> states = ['Andhra Pradesh', 'Telangana', 'Karnataka'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;
    selectedState = state;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Account',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: ColorsUtil.onPrimary,
              ),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: SizedBox(
                  width: 160, // Equal to radius * 2
                  height: 160,
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2024/05/27/12/27/gargoyle-8791108_640.jpg",
                    fit: BoxFit.cover, // Ensures the image fills the circle
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Name Field
            isEditing
                ? Reusable.customField('Name', nameController)
                : ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Name'),
                    subtitle: Text(name),
                  ),
            SizedBox(height: 16),
            // Phone Field
            isEditing
                ? Reusable.customField('Phone', phoneController)
                : ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'),
                    subtitle: Text(phone),
                  ),
            SizedBox(height: 16),
            // Email Field
            isEditing
                ? Reusable.customField('Email', emailController)
                : ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text(email),
                  ),
            SizedBox(height: 16),
            // State Dropdown
            isEditing
                ? DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: Reusable.border(),
                      focusedBorder: Reusable.focus_border(),
                    ),
                    items: states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(
                          state,
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedState = newValue;
                      });
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('State'),
                    subtitle: Text(state),
                  ),
            SizedBox(height: 24),
            if (isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.primaryColor,
                      ),
                      onPressed: () {
                        // Save the changes
                        setState(() {
                          name = nameController.text;
                          phone = phoneController.text;
                          email = emailController.text;
                          state = selectedState!;
                          isEditing = false;
                        });
                      },
                      child: Text(
                        "Save",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    // width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.primaryColor,
                      ),
                      onPressed: () {
                        // Cancel editing
                        setState(() {
                          isEditing = false;
                          nameController.text = name;
                          phoneController.text = phone;
                          emailController.text = email;
                          selectedState = state;
                        });
                      },
                      child: Text(
                        "Cancel",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
