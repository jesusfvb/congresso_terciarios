import 'package:congresso_terciarios/component/icon_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: Center(
                child: Image.asset(
                  'assets/img/img_1.jpg',
                  height: 300,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        style: TextStyle(fontSize: 25),
                        softWrap: true,
                        'Este aplicativo foi desenvolvido para uso exclusivo da Associação Internacional de Fiéis de Direito Pontifício Arautos do Evangelho. Está proibida sua cópia ou distribuição sem autorização do autor.Para qualquer informação adicional, entrar em contato com: '),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "aei@arautosdoevangelho.org.br",
                        textScaleFactor: 1.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: IconComponent.iconAppBar(
              icon: Icons.arrow_back,
              onPressed: () {
                Get.back();
              }),
        ));
  }
}
