// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These types are ignored because they are not used by any `pub` functions: `AppState`

void addOne() => RustLib.instance.api.crateApiSimpleAddOne();

int getNum() => RustLib.instance.api.crateApiSimpleGetNum();

bool whetherLike({required int num}) =>
    RustLib.instance.api.crateApiSimpleWhetherLike(num: num);

void addLike() => RustLib.instance.api.crateApiSimpleAddLike();

Int32List getAllLiked() => RustLib.instance.api.crateApiSimpleGetAllLiked();

Future<void> sumAll({required FutureOr<int> Function(int) dartCallback}) =>
    RustLib.instance.api.crateApiSimpleSumAll(dartCallback: dartCallback);
