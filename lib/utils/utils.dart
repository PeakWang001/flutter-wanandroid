import 'package:flutter_app2/widget/widgets.dart';

class Utils{

  static LoadState getLoadStatus( List data) {
    if (data == null) {
      return LoadState.loading;
    } else if (data.isEmpty) {
      return LoadState.empty;
    } else {
      return LoadState.success;
    }
  }
}