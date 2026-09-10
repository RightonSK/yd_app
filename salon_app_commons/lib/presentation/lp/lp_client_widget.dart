import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ClientWidget extends StatelessWidget {
  const ClientWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = context.watch<LPModel>().isMobile;
    return LPBaseContainer(
      isMobile: isMobile,
      bodyMaxWidth: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Client',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: isMobile ? 42 : 156,
                  height: 1,
                ),
          ),
          Text(
            '取引企業',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isMobile ? 14 : 24,
                  fontWeight: FontWeight.bold,
                  color: primaryNavyColor,
                ),
          ),
          SizedBox(height: isMobile ? 24 : 48),
          isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/img_techford.jpg',
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/img_dokodoor_logo.png',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/img_ritsuan_logo.png',
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/img_nain_logo.png',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/cinderelax.png',
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                              'salon_app_commons/resources/img_naut.png'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Image.asset(
                            'salon_app_commons/resources/img_ibj.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: 90,
                            child: Image.asset(
                              'salon_app_commons/resources/img_omiai.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'salon_app_commons/resources/img_techford.jpg',
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'salon_app_commons/resources/img_dokodoor_logo.png',
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'salon_app_commons/resources/img_ritsuan_logo.png',
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'salon_app_commons/resources/img_nain_logo.png',
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'salon_app_commons/resources/cinderelax.png',
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                          'salon_app_commons/resources/img_naut.png'),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                          'salon_app_commons/resources/img_ibj.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: 90,
                        child: Image.asset(
                          'salon_app_commons/resources/img_omiai.png',
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 48),
          Padding(
            padding: isMobile
                ? const EdgeInsets.symmetric(horizontal: 32)
                : const EdgeInsets.symmetric(horizontal: 56),
            child: LinkCard(
              title: t.about.engineer_introduction_button,
              isLight: false,
              isMobile: isMobile,
              isExternalLink: false,
              onTap: () {
                URLUtils.launch(
                  urlString: 'https://work.flutteruniv.com',
                );
              },
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
