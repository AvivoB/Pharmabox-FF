import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
import 'card_user_model.dart';
export 'card_user_model.dart';

class CardUserWidget extends StatefulWidget {
  const CardUserWidget({Key? key, this.data}) : super(key: key);

  final data;

  @override
  _CardUserWidgetState createState() => _CardUserWidgetState();
}

class _CardUserWidgetState extends State<CardUserWidget> {
  late CardUserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardUserModel());

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
                              image: widget.data != null && widget.data['photoUrl'] != null ? widget.data['photoUrl'] : '',
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
                                    widget.data['id'],
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
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Text(
                                  widget.data['nom'] ?? '' + ' ' + widget.data['prenom'] ?? '',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: Text(
                                  widget.data['poste'] ?? '',
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
                  Container(
                      child: ButtonNetworkManager(
                    // width: 30,
                    radius: 12.0,
                    fontSize: 14,
                    text: 'Ajouter',
                    // height: 25.0,
                    typeCollection: 'users',
                    docId: widget.data['id'],
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF595A71),
                    size: 35.0,
                  ),
                  if (widget.data['country'] != null)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        widget.data['city'] + ', ' + widget.data['country'],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF595A71),
                            ),
                      ),
                    ),
                  if (widget.data['country'] == null)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        widget.data['city'],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF595A71),
                            ),
                      ),
                    ),
                ],
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
                        documentId: widget.data['id'],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x00FFFFFF),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, 0.0),
                                  end: AlignmentDirectional(-1.0, 0),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Color(0x0042D2FF),
                                  borderRadius: 30.0,
                                  borderWidth: 0.0,
                                  buttonSize: 40.0,
                                  fillColor: Colors.white,
                                  icon: Icon(
                                    Icons.phone,
                                    color: Color(0xFF42D2FF),
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    await launch('tel:' + widget.data['telephone']);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, 0.0),
                                  end: AlignmentDirectional(-1.0, 0),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Color(0x0042D2FF),
                                  borderRadius: 30.0,
                                  borderWidth: 0.0,
                                  buttonSize: 40.0,
                                  fillColor: Colors.white,
                                  icon: Icon(
                                    Icons.mail_outline_rounded,
                                    color: Color(0xFF42D2FF),
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    await launch('mailto:' + widget.data['email']);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 0.0),
                                end: AlignmentDirectional(-1.0, 0),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                              child: FlutterFlowIconButton(
                                borderColor: Color(0x0042D2FF),
                                borderRadius: 30.0,
                                borderWidth: 0.0,
                                buttonSize: 40.0,
                                fillColor: Colors.white,
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: Color(0xFF42D2FF),
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiscussionUserWidget(toUser: widget.data['id']),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
