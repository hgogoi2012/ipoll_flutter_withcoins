import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';
import 'package:ipoll_application/no_internet.dart';

import 'package:ipoll_application/services/no_internet.dart';
import 'package:ipoll_application/services/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../const/firebase_instance.dart';
import '../providers/user_provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  bool isInternet = true;
  bool _isLoading = true;
  final User? user = authInstance.currentUser;

  String? name;
  String? upi_id;
  String? phonenumber;
  String? _profilePicture;
  String? _email;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _upiController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  late Uint8List _file;
  bool? isEnabled;
  String? fixedname;
  String? fixedemail;

  Future<void> updatePicture(Uint8List profImage) async {
    try {
      String _uid = authInstance.currentUser!.uid;

      TaskSnapshot upload = await FirebaseStorage.instance
          .ref()
          .child('profilePic')
          .child(_uid)
          .putData(profImage);

      String downloadUrl = await upload.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(_uid).update(
        {'profilePicture': downloadUrl},
      );
      await FirebaseFirestore.instance
          .collection('userranking')
          .doc(_uid)
          .update(
        {'image': downloadUrl},
      );
    } catch (e) {
      print(e);
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Change your Avatar'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? filetemp = await pickImage(ImageSource.camera);
                  if (filetemp != null) {
                    Uint8List file = filetemp;

                    setState(() {
                      _file = file;
                    });

                    final newImage = await updatePicture(file);
                    setState(() {
                      // _profilePicture = newImage;
                    });
                    getUserData();

                    // FirebaseMethods.uploadImage(_file);
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? filetemp = await pickImage(ImageSource.gallery);
                  if (filetemp != null) {
                    Uint8List file = filetemp;
                    setState(() {
                      _file = file;
                    });
                    Fluttertoast.showToast(
                      msg: "Profile Avatar Updated Successfully",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                    updatePicture(_file); // FirebaseMethods.uploadImage(_file);
                    getUserData();
                  }
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> getUserData() async {
    isInternet = await InternetConnectionChecker().hasConnection;
    if (isInternet) {
      if (mounted) {
        (() {
          _isLoading = true;
          isInternet = true;
        });
        if (user == null) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
        try {
          String uid = user!.uid;

          final DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          phonenumber = userDoc.get('phone');
          upi_id = userDoc.get('upiId');
          name = userDoc.get('name');
          _profilePicture = userDoc.get('profilePicture');
          _email = userDoc.get('email');
          // _nameController.text = userDoc.get('name');
          _phoneController.text = userDoc.get('phone');
          _upiController.text = userDoc.get('upiId');
          _emailController.text = userDoc.get('email');
          fixedname = name;
          _nameController.text = fixedname!;
          fixedemail = _email;

          setState(() {
            _profilePicture = _profilePicture;
          });
        } catch (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    } else {
      setState(() {
        isInternet = false;
      });
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState!.validate();
    String uid = authInstance.currentUser!.uid;

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'email': _emailController.text,
          'name': _nameController.text,
        });
        await FirebaseFirestore.instance
            .collection('userranking')
            .doc(uid)
            .update({
          'name': _nameController.text,
        });
        Fluttertoast.showToast(
          msg: "Profile Details Updated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
      } catch (error) {
        print(error);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> updateProfilePic() async {
    String uid = user!.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final String image = userDoc.get('profilePicture');

    return image;
  }

  @override
  Widget build(BuildContext context) {
    // _nameController.text = fixedname!;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);

    final getUser = userProvider.getUser;

    setState(() {
      _profilePicture = getUser.image;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: theme.focusColor,
          ),
        ),
        backgroundColor: theme.primaryColor,
        leading: const BackArrowNav(),
        elevation: 0,
      ),
      body: Consumer<InternetService>(builder: (context, model, child) {
        return model.internetTracker
            ? SafeArea(
                child: Container(
                  color: const Color.fromRGBO(230, 239, 250, 1),
                  child: Column(
                    children: [
                      FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox(
                                height: 50,
                                child: const SpinKitCircle(
                                  color: Colors.black,
                                  size: 30,
                                ),
                              );
                              // return ClipOval(
                              //   child: SizedBox.fromSize(
                              //     size: const Size.fromRadius(70),
                              //     child: CachedNetworkImage(
                              //         imageUrl:
                              //             "https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/profilePic%2Fblank.png?alt=media&token=2d62b060-d222-4f42-8bd8-3674246136f6",
                              //         width: 140,
                              //         height: 140,
                              //         fit: BoxFit.cover,
                              //         placeholder: (context, url) =>
                              //             const SpinKitFoldingCube(
                              //               color: Colors.black,
                              //             )),
                              //   ),
                              // );
                            }
                            if (snapshot.hasData) {
                              final profilePic = snapshot.data as String;
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Stack(
                                    children: [
                                      ClipOval(
                                          child: SizedBox.fromSize(
                                        size: const Size.fromRadius(70),
                                        child: CachedNetworkImage(
                                            imageUrl: profilePic,
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SpinKitFoldingCube(
                                                  color: Colors.black,
                                                )),
                                      )),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _selectImage(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: theme.primaryColor,
                                              ),
                                              height: 50,
                                              width: 50,
                                              child: const Icon(
                                                Icons.file_upload,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const Text('Loadinggg');
                          },
                          future: updateProfilePic()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 20),
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Name can\'t be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    hintText: fixedname,
                                    labelStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 20),
                                  controller: _emailController,
                                  // onChanged: (content) {
                                  //   if (content != fixedemail) {
                                  //     setState(() {
                                  //       isEnabled = true;
                                  //     });
                                  //   }
                                  // },
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains("@")) {
                                      return "Please enter a valid Email adress";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                  controller: _phoneController,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateProfile();
                                    },
                                    child: _isLoading
                                        ? const SpinKitCircle(
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : const Text(
                                            'Update Details',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : const NoInternetPage();
      }),
    );
  }
}
