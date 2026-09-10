import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'study_material_top_model.dart';

class SampleCodesCard extends StatelessWidget {
  const SampleCodesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<StudyMaterialsTopModel>(context);
    final sampleCodes = model.sampleCodes;
    return Card(
      child: SizedBox(
        height: 216,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'サンプルコード',
                style: BoldMultiLineStyle(fontSize: 20),
              ),
              const Text(
                'Flutter大学メンバーによる様々なサンプルコードです。',
                style: MultiLineStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Builder(builder: (context) {
                  if (sampleCodes == null) {
                    return const FlutterUnivLoadingIndicator(width: 32);
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: sampleCodes.map((sampleCode) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: InkWell(
                          onTap: () {
                            URLUtils.launch(
                              urlString: sampleCode.githubURL,
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5,
                                  spreadRadius: .1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.black12,
                                    child: const Icon(
                                      FontAwesome5.github,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 88,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sampleCode.title,
                                          style: const BoldMultiLineStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          sampleCode.description,
                                          style: const MultiLineStyle(
                                              fontSize: 12),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
