import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';

class SupportView extends ConsumerStatefulWidget {
  const SupportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportViewState();
}

class _SupportViewState extends ConsumerState<SupportView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(centerTitle: true, title: "Support view"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("email"), Text("phone n")],
      ),
    );
  }
}
