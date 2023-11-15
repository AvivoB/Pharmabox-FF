import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/composants/card_pharmablabla/card_pharmablabla_model.dart';

import '../../constant.dart';
import '../../custom_code/widgets/button_network_manager.dart';
import '../../custom_code/widgets/like_button.dart';
import '../../discussion_user/discussion_user_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardPharmablabla extends StatefulWidget {
  const CardPharmablabla({Key? key, this.data}) : super(key: key);

  final data;

  @override
  _CardPharmablablaState createState() => _CardPharmablablaState();
}

class _CardPharmablablaState extends State<CardPharmablabla> {
  late CardPharmablablaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardPharmablablaModel());

    print(widget.data);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        // height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(31, 92, 103, 0.17),
              offset: Offset(10.0, 10.0),
              blurRadius: 12.0,
              spreadRadius: -6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: FadeInImage.assetNetwork(
                              image: widget.data != null ? widget.data['user']['photoUrl'] : '',
                              placeholder: 'assets/images/Group_18.png',
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/Group_18.png');
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            context.pushNamed('ProfilView',
                                queryParams: {
                                  'userId': serializeParam(
                                    widget.data['user']['id'],
                                    ParamType.String,
                                  ),
                                }.withoutNulls)
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Text(
                                  widget.data['user']['nom'] + ' ' + widget.data['user']['prenom'],
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.data['user']['poste'] ?? '',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF8D8D97),
                                        fontSize: 13.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(widget.data['post']['date_created'].toDate()), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 9.0)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Text(
                  widget.data['post']['post_content'],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 15.0),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                color: Color(0xFFEFF6F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: LikeButtonWidget(
                        documentId: widget.data['postId'],
                      ),
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 90,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(Icons.notes_outlined, color: greyColor),
                              SizedBox(width: 8),
                              Text(
                                widget.data['post']['count_comment'].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
