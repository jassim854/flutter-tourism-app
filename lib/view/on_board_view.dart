import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/provider/on_board_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/widgets/container_bar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button.dart';

class OnBoardView extends ConsumerWidget {
  static const routeName = "/onBoardView";
  const OnBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep=ref.watch(onBoardProvider);
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundColor,
      body: Column(children: [
        SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ContainerBarWidget(
                          color: AppColor.surfaceBrandDarkColor,
                        ),
                      ),
                      8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                          color: currentStep>=2?AppColor.surfaceBrandDarkColor : AppColor.surfaceBackgroundBaseColor,
                        ),
                      ),
                            8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                              color:currentStep>=3?AppColor.surfaceBrandDarkColor : AppColor.surfaceBackgroundBaseColor,
                        ),
                      ),
                            8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                              color:currentStep==4?AppColor.surfaceBrandDarkColor : AppColor.surfaceBackgroundBaseColor,
                        ),
                      )
                    ],
                  ),
                  10.height(),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Steps $currentStep / 4,",style: AppTypography.title18LG,),
              CustomElevatedButton(
                onPressed: (){

              },title: "Skip",
              
              textColor: AppColor.textWhiteColor,
              )
              ],
            ),
                ],
              ),
            )),
          
        Expanded(
          child: PageView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(),
                  Container(),
                  Container(),
                  CustomElevatedButton(
                    onPressed: () {
                      ref.read(onBoardProvider.notifier).state++;

                    },
                    title: "Next",
                  )
                ],
              );
            },
          ),
        )
      ]),
    );
  }
}
