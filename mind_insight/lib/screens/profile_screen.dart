import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController ageC = TextEditingController();
  final TextEditingController genderC = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ---------- LOAD PROFILE SAFELY ------------
  Future<void> _loadProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      // Auto-create user document
      if (!doc.exists) {
        await docRef.set({
          'name': '',
          'phone': '',
          'age': '',
          'gender': '',
          'email': _auth.currentUser?.email ?? '',
        });
      }

      final data = (await docRef.get()).data() ?? {};

      nameC.text = data['name'] ?? '';
      phoneC.text = data['phone'] ?? '';
      ageC.text = data['age'] ?? '';
      genderC.text = data['gender'] ?? '';

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading profile: $e")));
    }
  }

  // ---------- SAVE PROFILE ------------
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).set({
        'name': nameC.text.trim(),
        'phone': phoneC.text.trim(),
        'age': ageC.text.trim(),
        'gender': genderC.text.trim(),
        'email': _auth.currentUser?.email ?? '',
      }, SetOptions(merge: true));
    }

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated Successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),

      appBar: AppBar(
        backgroundColor: pink,
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: pink))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    const Center(child: Icon(Icons.person, size: 90, color: pink)),

                    const SizedBox(height: 30),

                    _buildField("Name", nameC),
                    _buildField("Phone", phoneC),
                    _buildField("Age", ageC),
                    _buildField("Gender", genderC),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    const Color pink = Color(0xFFE91E63);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: pink, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
