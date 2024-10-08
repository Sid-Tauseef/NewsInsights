import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/widgets/Sizedbox.dart';
import 'my_account_screen.dart'; // Import the MyAccountScreen here

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    });
  }

  Future getGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(153, 137, 133, 189),
              Color.fromARGB(199, 40, 191, 255),
            ],
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomCenter,
            stops: [0.0, 0.8],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageProfile(),
              sizedH(context, 0.03),
              ProfileTile(
                height: height,
                forward: Icons.person,
                text: 'My Account',
                press: () {
                  // Navigate to the My Account screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyAccountScreen()),
                  );
                },
              ),
              sizedH(context, 0.03),
              ProfileTile(
                height: height,
                forward: Icons.help_center,
                text: 'Help Center',
                press: () => {},
              ),
              sizedH(context, 0.03),
              ProfileTile(
                height: height,
                forward: Icons.logout,
                text: 'Log Out',
                press: () => Navigator.pushReplacementNamed(context, 'login/'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget picking() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
        const Text(
          "Choose Profile Photo",
          style: TextStyle(fontSize: 20, fontFamily: "Montserrat"),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: getImage,
              icon: const Icon(Icons.camera, color: Colors.blue),
              label: const Text('Camera',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            TextButton.icon(
              onPressed: getGallery,
              icon: const Icon(Icons.image, color: Colors.blue),
              label: const Text('Gallery',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ]),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 60,
          child: ClipOval(
            child: SizedBox(
              height: 120.0,
              width: 120.0,
              child: image == null
                  ? Image.asset(
                      'assets/image/index1.jpg',
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 5,
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 137, 207, 240), // Light blue button
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => {
                showModalBottomSheet(
                    context: context, builder: ((builder) => picking()))
              },
              child: const Icon(
                Icons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.height,
    required this.text,
    required this.forward,
    this.press,
  });

  final double height;
  final String text;
  final IconData forward;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.2), // Updated tile background
        ),
        height: height * 0.07,
        child: Row(
          children: [
            Icon(forward, color: Colors.white), // Updated icon color
            sizedW(context, 0.04),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Updated text color for better contrast
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white), // Icon color
          ],
        ),
      ),
    );
  }
}
