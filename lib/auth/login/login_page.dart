import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/auth/auth_data.dart';
import 'package:sample_pwa/auth/auth_providers.dart';
import 'package:sample_pwa/auth/helpers/snackbar_helpers.dart';
import 'package:sample_pwa/auth/login/data/login_model.dart';
import 'package:sample_pwa/auth/login/data/login_providers.dart';
import 'package:sample_pwa/common_widgets/flutter_custom_logo.dart';
import 'package:sample_pwa/counts/count_page.dart';

class LoginPage extends HookConsumerWidget {
  static const routeName = 'login';

  LoginPage({super.key});

  final GlobalKey<FormState> loginFormKey = GlobalKey();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        // ),
        body: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(64.0),
            decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(4.0)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      spacing: 32.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FlutterCustomLogo(),
                        TextFormField(
                          textAlign: TextAlign.center,
                          decoration:
                              const InputDecoration(hintText: 'Enter username'),
                          controller: usernameController,
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return 'Please type something';
                            } else if (input != 'rakesh.verma') {
                              return 'Invalid username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                            onPressed: () async {
                              final formState = loginFormKey.currentState;
                              if (formState?.validate() != true) {
                                return;
                              }
                              formState?.save();

                              loading.value = true;
                              final loginParam =
                                  LoginParam(userName: usernameController.text);
                              final loginResponse = await ref
                                  .read(loginProvider(loginParam).future);
                              if (loginResponse.success) {
                                final authData =
                                    AuthData(token: loginResponse.token);
                                ref
                                    .read(authDataNotifierProvider.notifier)
                                    .refreshState(authData);

                                SnackBarHelpers.showSnackBar(
                                    context, 'YaY! Logged In');

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CountPage()),
                                );
                              }
                              loading.value = false;
                            },
                            child: const Text('Login'))
                      ],
                    ),
                  ),
                ),
                if (loading.value == true) ...{
                  const AbsorbPointer(
                      child: Center(
                    widthFactor: double.infinity,
                    heightFactor: double.infinity,
                    child: CircularProgressIndicator(),
                  ))
                }
              ],
            )));
  }
}
