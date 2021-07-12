import 'dart:io';
import 'dart:ui' as ui;

import 'package:cc_avenue_new/src/cc_avenue_details.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Widget CcAvenue(BuildContext context, CCAvenueDetails details) {
  final String viewType = 'cc-avenue-view-type';

  Size size = ui.window.physicalSize / ui.window.devicePixelRatio;

  details.toMap().update("width", (v) => size.width);
  details.toMap().update("height", (v) => size.height);

  return Platform.isIOS
      ? UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: details.toMap(),
          creationParamsCodec: const StandardMessageCodec(),
        )
      : Container();
}
