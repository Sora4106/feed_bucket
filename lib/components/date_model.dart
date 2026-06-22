import '/flutter_flow/flutter_flow_util.dart';
import 'date_widget.dart' show DateWidget;
import 'package:flutter/material.dart';

class DateModel extends FlutterFlowModel<DateWidget> {
  ///  Local state fields for this component.

  String date = '';

  ///  State fields for stateful widgets in this component.

  // State field(s) for year widget.
  FocusNode? yearFocusNode;
  TextEditingController? yearTextController;
  String? Function(BuildContext, String?)? yearTextControllerValidator;
  // State field(s) for month widget.
  FocusNode? monthFocusNode;
  TextEditingController? monthTextController;
  String? Function(BuildContext, String?)? monthTextControllerValidator;
  // State field(s) for day widget.
  FocusNode? dayFocusNode;
  TextEditingController? dayTextController;
  String? Function(BuildContext, String?)? dayTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yearFocusNode?.dispose();
    yearTextController?.dispose();

    monthFocusNode?.dispose();
    monthTextController?.dispose();

    dayFocusNode?.dispose();
    dayTextController?.dispose();
  }
}
