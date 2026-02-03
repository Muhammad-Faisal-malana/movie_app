import 'package:demo_app/core/bloc/connectivity_bloc.dart';
import 'package:demo_app/core/common_widget/no_internet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          if (!_isDialogOpen) {
            _isDialogOpen = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const NoInternetDialog(),
            );
          }
        } else if (state is ConnectivityConnected) {
          if (_isDialogOpen) {
            _isDialogOpen = false;
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      child: widget.child,
    );
  }
}
