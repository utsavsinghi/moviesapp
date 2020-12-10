import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Movies>(
      child: WidgetsApp(
        title: 'Flutter Demo',
        color: Colors.grey[850],
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          return MaterialPageRoute<T>(settings: settings, builder: builder);
        },
        home: HomePage(),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
      ),
      create: (_) => Movies(<Movie>[
        Movie(
          'The Lion King',
          'Simba, a young lion prince, flees his kingdom after the murder of his father, Mufasa. '
              'Years later, a chance encounter with Nala, a lioness, causes him to return and take '
              'back what is rightfully his.',
          ['Animation', 'Family'],
          '1h 58m',
          6.9,
          'assets/lion-king-poster.jpg',
          'assets/lion-king-logo.png',
          r'-FDuSQ~9E3Ipso%004M}NHM|xZ%0^ioe$%xZNHR+E3xY%0%0oeIpE3E3j]t6WBWB%0-nxsoefkWCIWM|V[oLofoextoyoJn%jZbH',
        ),
        Movie(
          'Aladdin',
          'Aladdin, a kind thief, woos Jasmine, the princess of Agrabah, with the help of Genie. '
              'When Jafar, the grand vizier, tries to usurp the king, Jasmine, Aladdin and '
              'Genie must stop him from succeeding.',
          ['Family', 'Romance'],
          '2h 8m',
          7.0,
          'assets/aladdin-poster.jpg',
          'assets/aladdin-logo.png',
          r'-OFE+$?sxuRoIqWG.7~8=|o#R-NIVur;xm-n%LozDlE4s*%0%Jox0#rxnTWAoafz^ONfEMVsRjs.WroexHR:V]V@j;n$W=oJjvs:',
        ),
        Movie(
          'Captain Marvel',
          'Amidst a mission, Vers, a Kree warrior, gets separated from her team and is stranded '
              'on Earth. However, her life takes an unusual turn after she teams up with Fury,'
              ' a S.H.I.E.L.D. agent.',
          ['Action', 'Sci-fi'],
          '2h 5m',
          6.9,
          'assets/captain-marvel-poster.jpg',
          'assets/captain-marvel-logo.png',
          r'-8IWTj1805tk00t*=oNN0Kv{%g^i0J^Q1#-B~qR6JDIn=|%3R%0f00%0=?M{}tR4E.t4?GRPROxwHrInabbFyDTfXA$*ShXnogSh',
        ),
      ]),
      lazy: false,
    );
  }
}
