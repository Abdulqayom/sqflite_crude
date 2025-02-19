import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_crud/provider.dart';
import 'package:sqflite_crud/userdetails.dart';
import 'package:sqflite_crud/usermodel.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  void _navigateToDetail(BuildContext context, {User? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design using MediaQuery.
    final media = MediaQuery.of(context);
    final isLargeScreen = media.size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userProvider.users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 24 : 8,
                  vertical: 8,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        user.image.isNotEmpty ? NetworkImage(user.image) : null,
                    child: user.image.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .deleteUser(user.id!);
                    },
                  ),
                  onTap: () => _navigateToDetail(context, user: user),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
