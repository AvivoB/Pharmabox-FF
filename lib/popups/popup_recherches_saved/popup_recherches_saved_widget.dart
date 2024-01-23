import 'package:pharmabox/composants/card_offers_profile/card_offers_profile.dart';
import 'package:pharmabox/composants/card_searchs_profile/card_searchs_profile.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/register_step/register_provider.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_recherches_saved_model.dart';
export 'popup_recherches_saved_model.dart';

class PopupSearchSaved extends StatefulWidget {
  PopupSearchSaved({Key? key, required this.onTap, required this.searchSaved, required this.isOffer, this.itemSelected = 0, required this.onSave}) : super(key: key);
  final Function onTap;
  final Function onSave;
  final List searchSaved;
  final bool? isOffer;
  int itemSelected;

  @override
  _PopupSearchSavedState createState() => _PopupSearchSavedState();
}

class _PopupSearchSavedState extends State<PopupSearchSaved> {
  late PopupSearchSavedModel _model;

  bool isLongPressed = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupSearchSavedModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Vos recherches enregistrées',
                      style: FlutterFlowTheme.of(context).displaySmall,
                    ),
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      buttonSize: 60.0,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    if (widget.isOffer == false)
                      for (int index = 0; index < widget.searchSaved.length; index++)
                        GestureDetector(
                          onLongPress: () {
                            setState(() {
                              widget.itemSelected = index;
                            });
                            widget.onTap(index);
                            Navigator.pop(context);
                          },
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.itemSelected == index)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0),
                                  child: Text('Recherche séléctionnée', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
                                ),
                              CardSearchProfilWidget(
                                searchI: widget.searchSaved[index], 
                                isSelected: widget.itemSelected == index ? true : false,
                                onSave: (data) {
                                  widget.onSave(data);
                                },
                              ),
                            ],
                          )),
                        ),
                    if (widget.isOffer == true)
                      for (int index = 0; index < widget.searchSaved.length; index++)
                        GestureDetector(
                          onLongPress: () {
                            setState(() {
                              widget.itemSelected = index;
                            });
                            widget.onTap(index);
                            Navigator.pop(context);
                          },
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.itemSelected == index)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0),
                                  child: Text('Recherche séléctionnée', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
                                ),
                              CardOfferProfilWidget(
                                searchI: widget.searchSaved[index],
                                isSelected: widget.itemSelected == index ? true : false,
                                onSave: (data) {
                                  widget.onSave(data);
                                },
                              ),
                            ],
                          )),
                        )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
