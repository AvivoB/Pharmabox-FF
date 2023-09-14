// // Preferences contact
// Padding(
//   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
//   child: Container(
//     height: 50,
//     decoration: BoxDecoration(
//       color: FlutterFlowTheme.of(context).secondaryBackground,
//       borderRadius: BorderRadius.circular(4),
//       border: Border.all(
//         color: Color(0xFFD0D1DE),
//       ),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
//           child: Icon(
//             Icons.settings_outlined,
//             color: FlutterFlowTheme.of(context).secondaryText,
//             size: 24,
//           ),
//         ),
//         FlutterFlowDropDown<String>(
//           controller: _model.preferenceContactValueController ??= FormFieldController<String>(null),
//           options: ['Tous ', 'Perso', 'Pharmacie'],
//           onChanged: (val) => setState(() => _model.preferenceContactValue = val),
//           width: MediaQuery.of(context).size.width * 0.75,
//           height: 50,
//           textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
//                 fontFamily: 'Poppins',
//                 color: Colors.black,
//               ),
//           hintText: 'Préférences de contact',
//           fillColor: Colors.white,
//           elevation: 2,
//           borderColor: Colors.transparent,
//           borderWidth: 0,
//           borderRadius: 0,
//           margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
//           hidesUnderline: true,
//           isSearchable: false,
//         ),
//       ],
//     ),
//   ),
// ),

// // Pharmacie maitre de stage
// Padding(
// padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
// child: Row(
//   mainAxisSize: MainAxisSize.max,
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
//           child: Icon(
//             Icons.school_sharp,
//             color: Color(0xFF595A71),
//             size: 28,
//           ),
//         ),
//         Text(
//           'Pharmacie maître de stage',
//           style: FlutterFlowTheme.of(context).bodyMedium,
//         ),
//       ],
//     ),
//     Switch.adaptive(
//       value: _model.comptencesTestCovidValue ??= false,
//       onChanged: (newValue) async {
//         setState(() => _model.comptencesTestCovidValue = newValue);
//       },
//       activeColor: Color(0xFF7CEDAC),
//     ),
//   ],
// ),
// ),
