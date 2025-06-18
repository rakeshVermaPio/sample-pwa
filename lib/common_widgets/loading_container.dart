import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingContainer(
      {super.key, required this.child, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        padding: const EdgeInsets.all(64.0),
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          children: [
            child,
            if (isLoading == true) ...{
              const AbsorbPointer(
                  child: Center(
                widthFactor: double.infinity,
                heightFactor: double.infinity,
                child: CircularProgressIndicator(),
              ))
            }
          ],
        ));
  }
}
