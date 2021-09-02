/*
 * rflutter_alert
 * Created by Ratel
 * https://ratel.com.tr
 * 
 * Copyright (c) 2018 Ratel, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/src/custom_animated_container.dart';

import 'alert_style.dart';
import 'animation_transition.dart';
import 'constants.dart';
import 'dialog_button.dart';

/// Main class to create alerts.
///
/// You must call the "show()" method to view the alert class you have defined.
class Alert {
  final BuildContext context;
  final AlertType type;
  final AlertStyle style;
  final Image image;
  final String title;
  final String desc;
  final String desc1;
  final String desc2;
  final String desc3;
  final Widget content;
  final List<DialogButton> buttons;
  final Function closeFunction;

  /// Alert constructor
  ///
  /// [context], [title] are required.
  Alert({
    @required this.context,
    this.type,
    this.style = const AlertStyle(),
    this.image,
    this.title,
    this.desc,
    this.desc1,
    this.desc2,
    this.desc3,
    this.content,
    this.buttons,
    this.closeFunction,
  });

  /// Displays defined alert window
  Future<bool> show() async {
    return await showGeneralDialog(
      context: context,

      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _buildDialog();
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,

      transitionDuration: style.animationDuration,
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          _showAnimation(animation, secondaryAnimation, child),
      // child: _buildDialog(),
    );
  }

// Will be added in next version.
  // void dismiss() {
  //   Navigator.pop(context);
  // }

  // Alert dialog content widget
  Widget _buildDialog() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Center(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: AlertDialog(
                backgroundColor: style.backgroundColor ??
                    Theme.of(context).dialogBackgroundColor,
                shape: _defaultShape(),
                // titlePadding: EdgeInsets.all(16.0),
                title: Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: title == null ? 0 : 8,
                      ),
                      title != null
                          ? Text(
                              title,
                              style: style.titleStyle,
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      SizedBox(
                        height: title == null ? 0 : 16,
                      ),
                      _getImage(),
                      desc == null
                          ? Container()
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: style.descStyle,
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                    text: desc,
                                  ),
                                  TextSpan(text: desc1),
                                  TextSpan(
                                    text: desc2,
                                  ),
                                  TextSpan(text: desc3),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: desc == null ? 0 : 24,
                      ),
                      content == null ? Container() : content,
                    ],
                  )),
                ),
                contentPadding: style.buttonAreaPadding,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getButtons(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns alert default border style
  ShapeBorder _defaultShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    );
  }

// Returns the close button on the top right
  Widget _getCloseButton() {
    return style.isCloseButton
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
              closeFunction();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: Container(
                alignment: FractionalOffset.topRight,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        '$kImagePath/close.png',
                        package: 'rflutter_alert',
                      ),
                    ),
                  ),
                  child: Container(),
                ),
              ),
            ),
          )
        : Container();
  }

  // Returns defined buttons. Default: Cancel Button
  List<Widget> _getButtons() {
    List<Widget> expandedButtons = [];
    if (buttons != null) {
      buttons.forEach(
        (button) {
          var buttonWidget = Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
            child: button,
          );
          if (button.width != null && buttons.length == 1) {
            expandedButtons.add(buttonWidget);
          } else {
            expandedButtons.add(Expanded(
              child: buttonWidget,
            ));
          }
        },
      );
    } else {
      expandedButtons.add(
        Expanded(
          child: DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
    }

    return expandedButtons;
  }

// Returns alert image for icon
  Widget _getImage() {
    Widget response = image != null
        ? Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 24), child: image)
        : Container();
    switch (type) {
      case AlertType.success:
        response = Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: Image.asset(
              '$kImagePath/icon_success.png',
              package: 'rflutter_alert',
            ));
        break;
      case AlertType.error:
        response = Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: Image.asset(
              '$kImagePath/icon_error.png',
              package: 'rflutter_alert',
            ));
        break;
      case AlertType.info:
        response = Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: Image.asset(
              '$kImagePath/icon_info.png',
              package: 'rflutter_alert',
            ));
        break;
      case AlertType.warning:
        response = Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: Image.asset(
              '$kImagePath/icon_warning.png',
              package: 'rflutter_alert',
            ));
        break;
      case AlertType.none:
        response = Container();
        break;
    }
    return response;
  }

// Shows alert with selected animation
  _showAnimation(animation, secondaryAnimation, child) {
    return AnimationTransition.grow(animation, secondaryAnimation, child);
  }
}
