import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/common_widgets/message_view.dart';
import 'package:sample_pwa/local/database.dart';
import 'package:sample_pwa/users/data/user_providers.dart';

class UserListPage extends HookConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUserListProvider).when(
      data: (userList) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Counts'),
          ),
          body: (userList?.isEmpty ?? true)
              ? const MessageView(message: 'User count is empty')
              : ListView.builder(
                  itemCount: userList?.length,
                  itemBuilder: (context, index) {
                    final user = userList![index];
                    return _buildUserListTile(user);
                  }),
        );
      },
      error: (obj, objectTrace) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Counts'),
          ),
          body: MessageView(message: objectTrace.toString()),
        );
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Counts'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildUserListTile(User user) {
    return Card(child: ListTile(title: Text(user.name)));
  }
}
