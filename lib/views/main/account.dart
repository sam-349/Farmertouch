import 'dart:convert'; // Import for base64 encoding/decoding
import 'dart:io';
import 'dart:typed_data';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/blog_model.dart';
import 'package:farmers_touch/models/product_model.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/blog_repo.dart';
import 'package:farmers_touch/repo/product_repo.dart';
import 'package:farmers_touch/repo/user_repo.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:farmers_touch/views/main/productDetail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http; // Import for making API calls
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:farmers_touch/models/login_model.dart'; // Import your User model
import 'package:path_provider/path_provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  Pic? profilePic;
  // List<dynamic> userProducts = [];
  bool isEditing = false;
  bool isLoading = true;
  bool isSaving = false;
  bool isGettingDetails = false;
  List<BlogModel> userBlogs = [];
  List<ProductModel> userProducts = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  late TabController _tabController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isGettingDetails = true;
      });
      final data = await BlogRepo().getBlogsByUserId(
          Provider.of<UserProvider>(context, listen: false).userID!);
      if (data != null) {
        if (mounted) {
          setState(() {
            userBlogs = data!;
          });
        }
      }
      final userData = await ProductRepo().getUserProducts(
          Provider.of<UserProvider>(context, listen: false).userID!);
      // debugPrint(userData![0].productName);
      if (userData != null) {
        debugPrint("successfully got products");
        if (mounted) {
          setState(() {
            debugPrint("initialized");
            userProducts = userData!;
          });
        }
      }
      setState(() {
        isGettingDetails = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      setState(() {
        nameController.text = user.username!;
        phoneController.text = user.phonenumber!;
        emailController.text = user.mail!;
        locationController.text = user.location!;
        if (user.pic != null) {
          profilePic = user.pic;
        }
      });
      // _fetchUserProducts();
    } else {
      // Handle case where user is not available
      print('User data not available');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchUserProducts() async {
    try {
      final response =
          await http.get(Uri.parse('YOUR_API_ENDPOINT/products/user'));

      if (response.statusCode == 200) {
        setState(() {
          userProducts = jsonDecode(response.body);
        });
      } else {
        print('Failed to load user products');
      }
    } catch (e) {
      print('Error fetching user products: $e');
    }
  }

  Future<File?> picToFile(Pic? pic) async {
    debugPrint("pic to file conversion entered");
    if (pic == null || pic.data == null || pic.data!.isEmpty) {
      debugPrint("pic is empty");
      return null; // No image data
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile =
          File('${tempDir.path}/temp_image.jpg'); // Or .png, based on your type

      await tempFile
          .writeAsBytes(pic.data!); // Write the image bytes to the file

      return tempFile;
    } catch (e) {
      print('Error converting Pic to File: $e');
      return null; // Return null on error
    }
  }

  Future<void> _saveUserData() async {
    try {
      setState(() {
        isSaving = true;
      });
      final user = Provider.of<UserProvider>(context, listen: false).user;
      debugPrint("update called");
      File? new_pic = (_image == null && user != null && user.pic != null)
          ? await picToFile(user.pic)
          : _image;

      // debugPrint("pic: ${user!.id}");
      debugPrint("password: ${user?.password}");
      final response = await UserRepo().updateUser(
        user!.id!,
        user.username,
        user.mail!,
        user.password!,
        user.phonenumber,
        user.location,
        user.type!,
        new_pic,
      );
      debugPrint("request placed");

      if (response != null) {
        debugPrint("user updated");
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final updatedUser = User(
          id: userProvider.user!.id,
          username: nameController.text,
          phonenumber: phoneController.text,
          mail: emailController.text,
          location: locationController.text,
          pic: response.pic,
          password: response.password,
          type: response.type,
          v: response.v,
        );

        await userProvider.setUser(updatedUser); // Update provider
        setState(() {
          profilePic = response.pic;
          isEditing = false;
          isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        print('Failed to update user data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } catch (e) {
      print('Error updating user data in catch: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context); // Close bottom sheet
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            icon: Icon(
              Icons.edit,
              color: ColorsUtil.onPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).clearUser();
            },
            icon: Icon(
              Icons.logout,
              color: ColorsUtil.onPrimary,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isEditing) {
                          // Handle profile picture update

                          _showImagePickerBottomSheet();
                          debugPrint("picture edit called");
                        }
                      },
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                        ),
                        // backgroundImage: (profilePic != null && _image == null)
                        // ? MemoryImage(
                        //     Uint8List.fromList(
                        //       profilePic!.data!.cast<int>(),
                        //     ),
                        //   )
                        // : null,
                        child: (profilePic != null && _image == null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Image.memory(
                                  Uint8List.fromList(
                                    profilePic!.data!.cast<int>(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (_image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : null),
                      ),
                    ),
                    SizedBox(height: 16),
                    isEditing
                        ? Reusable.customField('Name', nameController)
                        : ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Name'),
                            subtitle: Text(user?.username ?? ''),
                          ),
                    SizedBox(height: 16),
                    isEditing
                        ? Reusable.customField('Phone', phoneController)
                        : ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone'),
                            subtitle: Text(user?.phonenumber ?? ''),
                          ),
                    SizedBox(height: 16),
                    isEditing
                        ? Reusable.customField('Email', emailController)
                        : ListTile(
                            leading: Icon(Icons.email),
                            title: Text('Email'),
                            subtitle: Text(user?.mail ?? ''),
                          ),
                    SizedBox(height: 16),
                    // isEditing
                    //     ? Reusable.customField('Location', locationController)
                    //     : ListTile(
                    //         leading: Icon(Icons.location_on),
                    //         title: Text('Location'),
                    //         subtitle: Text(user?.location ?? ''),
                    //       ),
                    // SizedBox(height: 24),
                    if (isEditing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isSaving)
                              ? CircularProgressIndicator(
                                  color: ColorsUtil.primaryColor,
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsUtil.primaryColor,
                                  ),
                                  onPressed: _saveUserData,
                                  child: Text(
                                    "Save",
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsUtil.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                                nameController.text = user?.username ?? '';
                                phoneController.text = user?.phonenumber ?? '';
                                emailController.text = user?.mail ?? '';
                                locationController.text = user?.location ?? '';
                              });
                            },
                            child: Text(
                              "Cancel",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 32),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Products'),
                        Tab(text: 'Blogs'),
                      ],
                    ),
                    Container(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildProductsTab(),
                          _buildBlogsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductsTab() {
    if (isGettingDetails) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorsUtil.primaryColor,
        ),
      );
    }

    if (userProducts.isEmpty) {
      return Center(child: Text('No products posted yet.'));
    } else {
      return ListView.builder(
        itemCount: userProducts.length,
        itemBuilder: (context, index) {
          final product = userProducts[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: ((context) =>
              //         ProductDetailPage(productData: product)),
              //   ),
              // );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  if (product.image != null && product.image!.data != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        Uint8List.fromList(product.image!.data!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: Center(child: Icon(Icons.image)),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product.productName ?? 'Product'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Implement delete functionality here
                      // Example: deleteProduct(product);
                      final res =
                          await ProductRepo().deleteProduct(product.id!);
                      if (res) {
                        final data = await ProductRepo().getUserProducts(
                            Provider.of<UserProvider>(context, listen: false)
                                .userID!);
                        if (data != null) {
                          setState(() {
                            userProducts = data;
                          });
                        }
                      }
                      print('Delete product: ${product.productName}');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Colors.grey.shade300,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildBlogsTab() {
    if (isGettingDetails) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorsUtil.primaryColor,
        ),
      );
    }

    if (userBlogs == null || userBlogs.isEmpty) {
      return Center(child: Text('No blogs posted yet.'));
    } else {
      return ListView.builder(
        itemCount: userBlogs.length,
        itemBuilder: (context, index) {
          final blog = userBlogs[index];
          return Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                if (blog.images != null &&
                    blog.images!.isNotEmpty &&
                    blog.images![0].data != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      Uint8List.fromList(blog.images![0].data!),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.image)),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(blog.title ?? 'Blog'),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final res = await BlogRepo().deleteBlog(blog.id!);
                    if (res) {
                      final data = await BlogRepo().getBlogsByUserId(
                          Provider.of<UserProvider>(context, listen: false)
                              .userID!);
                      if (data != null) {
                        setState(() {
                          userBlogs = data;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      color: Colors.grey.shade300,
                    ),
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
