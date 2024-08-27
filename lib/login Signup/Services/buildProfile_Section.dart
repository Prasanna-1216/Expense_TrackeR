import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Widget _buildProfileSection() {
  // Get the current user
  final User? user = FirebaseAuth.instance.currentUser;

  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage('assets/profile.jpg') as ImageProvider,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(user?.email ?? 'No Email'),
            ],
          ),
        ],
      ),
    ),
  );
}
