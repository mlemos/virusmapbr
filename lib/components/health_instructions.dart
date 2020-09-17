import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class HealthInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HealthDataProvider healthDataProvider =
        Provider.of<HealthDataProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            "Preencha seu formulário de saúde",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            "Siga atentamente as instruções para preencher o formulário.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 32.0,
          ),
          Row(
            children: [
              Container(
                width: 48.0,
                height: 48.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Text("01",
                      style: Theme.of(context).textTheme.headline2.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                    "Por favor preencha os dados com informações reais.",
                    style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text2")))),
              ),
            ],
          ),
          SizedBox(height: 32.0),
          Row(
            children: [
              Container(
                width: 48.0,
                height: 48.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Text("02",
                      style: Theme.of(context).textTheme.headline2.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                    "Atualize o formulário sempre que houver alguma mudança.",
                    style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text2")))),
              ),
            ],
          ),
          SizedBox(height: 32.0),
          Row(
            children: [
              Container(
                width: 48.0,
                height: 48.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Text("03",
                      style: Theme.of(context).textTheme.headline2.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                    "Clique no botão salvar no final do formulário para gravar suas informações.",
                    style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text2")))),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Expanded(
                      child: Center(
                        child: Container(
              height: 48.0,
              padding: const EdgeInsets.fromLTRB(0,0,8,0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: VirusMapBRTheme.color(context, "error").withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    child: Center(
                        child: Icon(
                          Icons.lock_outline,
                          size: 20.0,
                          color: VirusMapBRTheme.color(context, "error"),
                        ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                        "Seus dados não serão compartilhados de forma identificada.",
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: VirusMapBRTheme.color(context, "error"))),
                    ),
                  ),
                ],
              ),
            ),
                      ),
          ),
          SizedBox(height: 8.0),
          _buildOkButton(context, healthDataProvider),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Row _buildOkButton(BuildContext context, HealthDataProvider healthDataProvider) {
    return Row(
          children: [
            Expanded(
              child: Container(
                height: 56.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Text(
                    "Entendi! Vamos lá...",
                    style: Theme.of(context).textTheme.headline3.merge(
                        TextStyle(
                            color: VirusMapBRTheme.color(context, "white"))),
                  ),
                  onPressed: () {
                    healthDataProvider.firstTime = false;
                  },
                ),
              ),
            )
          ],
        );
  }
}
