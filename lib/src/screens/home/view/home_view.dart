import 'package:flutter/material.dart';

import '../../../configs/size_config.dart';
import '../../../utils/routes/custom_routes.dart';
import '../../../utils/themes/themes.dart';
import '../../isar_back_links/isar_back_link_view.dart';
import '../../isar_link/isar_link_view.dart';
import '../../isar_links/isar_links_view.dart';
import '../../setting/view/setting_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(context, FadeRoute(page: const SettingView())),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: mainMin,
          children: [
            ElevatedButton(
              style: roundedButtonStyle,
              onPressed: () => Navigator.push(
                  context, FadeRoute(page: const IsarLinkView())),
              child: const Text('Isar Link'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: roundedButtonStyle,
              onPressed: () => Navigator.push(
                  context, FadeRoute(page: const IsarLinksView())),
              child: const Text('Isar Links'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: roundedButtonStyle,
              onPressed: () => Navigator.push(
                  context, FadeRoute(page: const IsarBackLinkView())),
              child: const Text('Isar Back Link'),
            ),
          ],
        ),
      ),
    );
  }
}
