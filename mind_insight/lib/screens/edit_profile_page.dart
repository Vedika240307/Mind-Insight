import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController genderCtrl = TextEditingController();
  final TextEditingController contactCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  // ---------------------------
  // 🔥 Load User Profile Data
  // ---------------------------
  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data()!;
      nameCtrl.text = (data["name"] ?? "").toString();
      ageCtrl.text = (data["age"] ?? "").toString();
      genderCtrl.text = (data["gender"] ?? "").toString();
      contactCtrl.text = (data["contact"] ?? "").toString();
      emailCtrl.text = (data["email"] ?? user.email!).toString();
    } else {
      // Create clean empty structure if user doc missing
      await docRef.set({
        "name": "",
        "age": "",
        "gender": "",
        "contact": "",
        "email": user.email ?? "",
      }, SetOptions(merge: true));

      emailCtrl.text = user.email ?? "";
    }

    setState(() => loading = false);
  }

  // ---------------------------
  // 🔥 Save Profile Data
  // ---------------------------
  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "name": nameCtrl.text.trim(),
      "age": ageCtrl.text.trim(),
      "gender": genderCtrl.text.trim(),
      "contact": contactCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
    }, SetOptions(merge: true)); // safe merge
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField("Full Name", nameCtrl),
                    _buildTextField(
                      "Age",
                      ageCtrl,
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField("Gender", genderCtrl),
                    _buildTextField(
                      "Contact Number",
                      contactCtrl,
                      keyboard: TextInputType.phone,
                    ),
                    _buildTextField(
                      "Email ID",
                      emailCtrl,
                      keyboard: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await saveProfile();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // --------------------------
  // Reusable Text Field Widget
  // --------------------------
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE91E63)),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
