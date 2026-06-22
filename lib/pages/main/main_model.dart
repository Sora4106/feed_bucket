import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'main_widget.dart' show MainWidget;
import 'package:flutter/material.dart';

class MainModel extends FlutterFlowModel<MainWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (DatebaseSQL)] action in Stack widget.
  ApiCallResponse? farmIDQueryCopy;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future mainreturn(BuildContext context) async {
    ApiCallResponse? opIDQuery;

    opIDQuery = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: 'id,opID',
      sqlWhere: 'farmID=$dropDownValue',
      sqlFrom: 'controller',
    );

    final bucketIds =
        DatebaseSQLCall.id((opIDQuery.jsonBody ?? ''))?.toList() ??
            const <String>[];
    final bucketNames =
        DatebaseSQLCall.opID((opIDQuery.jsonBody ?? ''))?.toList() ??
            const <String>[];
    final pairCount = bucketIds.length < bucketNames.length
        ? bucketIds.length
        : bucketNames.length;
    final visibleBucketIds = bucketIds.take(pairCount).toList();
    final visibleBucketNames = bucketNames.take(pairCount).toList();
    final sortOrder = functions.sortIndicesByNaturalOrder(visibleBucketNames);

    FFAppState().id = [
      for (final index in sortOrder) visibleBucketIds[index],
    ];
    FFAppState().opID = [
      for (final index in sortOrder) visibleBucketNames[index],
    ];
  }
}
