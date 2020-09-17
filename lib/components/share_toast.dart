import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';

class ShareToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: VirusMapBRTheme.color(context, "modal"),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            height: 48.0,
            width: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: VirusMapBRTheme.color(context, "primary").withOpacity(0.1),
            ),
            child: Center(
              child: Icon(VirusMapBRIcons.share,
                  color: VirusMapBRTheme.color(context, "primary")),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "Atualize sua família e seus amigos. ",
                  ),
                  TextSpan(
                    text:
                        "Compartilhe o app e ajude a reduzir a propagação do novo coronavírus. ",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Share.share(
                            "Vamos juntos acabar com o Coronavírus. Estou usando este app para monitorar o vírus. Baixe você também: http://github.com/mlemos/virusmapbr");
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
