import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'select_page_widget.dart' show SelectPageWidget;
import 'package:flutter/material.dart';

class SelectPageModel extends FlutterFlowModel<SelectPageWidget> {
  ///  Local state fields for this page.

  String opID = '';

  String selectRecordHigh = '';

  String specification = '';

  String ton = '';

  List<String> highList = [];
  void addToHighList(String item) => highList.add(item);
  void removeFromHighList(String item) => highList.remove(item);
  void removeAtIndexFromHighList(int index) => highList.removeAt(index);
  void insertAtIndexInHighList(int index, String item) =>
      highList.insert(index, item);
  void updateHighListAtIndex(int index, Function(String) updateFn) =>
      highList[index] = updateFn(highList[index]);

  int feedTime = 0;

  int feedTon = 0;

  String selectFlag = '';

  String selectChart = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - API (DatebaseSQL)] action in Button widget.
  ApiCallResponse? selectController;
  // Stores action output result for [Backend Call - API (DatebaseSQL)] action in Button widget.
  ApiCallResponse? selectFeedHigh;
  // Stores action output result for [Backend Call - API (DatebaseSQL)] action in Button widget.
  ApiCallResponse? selectWaitFlag;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
