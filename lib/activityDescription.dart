import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:conjugo/utils.dart';

//Page description des activités
class DescriptionPage extends StatelessWidget {
  String name;
  String description;
  // String genre = ""; // Pas implémenté, à rajouter
  String date;
  String place;
  String numberOfRemainingEntries;
  DescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.name,
      required this.description,
      required this.date,
      required this.place,
      required this.numberOfRemainingEntries});
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        //Le titre de la page est le nom de l'activité sur laquelle nous avons appuyée
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding:
                    EdgeInsets.fromLTRB(9 * fem, 0 * fem, 0 * fem, 5 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            7 * fem, 0 * fem, 0 * fem, 6 * fem),
                        width: 338 * fem,
                        height: 198 * fem,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0 * fem,
                              top: 18 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 331 * fem,
                                  height: 180 * fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * fem),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      color: const Color(0xffd9d9d9),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'images/logo.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: 293 * fem,
                                top: 0 * fem,
                                child: Align(
                                    child: SizedBox(
                                        width: 50 * fem,
                                        height: 50 * fem,
                                        child: Image.asset(
                                          'images/logo.png',
                                          width: 50 * fem,
                                          height: 50 * fem,
                                        ))))
                          ],
                        ))
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15),
              child: Row(
                children: [
                  const Text(
                    "Date : ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //     margin: EdgeInsets.fromLTRB(5 * fem, 0 * fem, 0 * fem, 8 * fem),
            //     child: RichText(
            //         text: TextSpan(
            //       style: SafeGoogleFont(
            //         'Inter',
            //         fontSize: 15 * ffem,
            //         fontWeight: FontWeight.w400,
            //         height: 1.2102272034 * ffem / fem,
            //         color: Color.fromARGB(255, 0, 0, 0),
            //       ),
            //       children: [
            //         TextSpan(
            //             text: 'Date :',
            //             style: SafeGoogleFont(
            //               'Inter',
            //               fontSize: 20 * ffem,
            //               fontWeight: FontWeight.w700,
            //               height: 1.2125 * ffem / fem,
            //               decoration: TextDecoration.underline,
            //               color: Color(0xff000000),
            //               decorationColor: Color(0xff000000),
            //             )),
            //         TextSpan(
            //           text: date,
            //           style: SafeGoogleFont(
            //             'Inter',
            //             fontSize: 15 * ffem,
            //             fontWeight: FontWeight.w400,
            //             height: 1.2125 * ffem / fem,
            //             color: Color(0xff000000),
            //           ),
            //         ),
            //         TextSpan(
            //           text: '',
            //           style: SafeGoogleFont(
            //             'Inter',
            //             fontSize: 15 * ffem,
            //             fontWeight: FontWeight.w700,
            //             height: 1.2125 * ffem / fem,
            //             color: Color(0xff000000),
            //           ),
            //         ),
            //       ],
            //     )
            //     )),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Text(
                    "Lieu : ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    place,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
              padding:
                  EdgeInsets.fromLTRB(10 * fem, 4 * fem, 11 * fem, 10 * fem),
              width: 343 * fem,
              decoration: BoxDecoration(
                color: Color(0xff0eb214),
                borderRadius: BorderRadius.circular(10 * fem),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // descriptionGtv (9:303)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                    child: Text(
                      'Description :',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        decoration: TextDecoration.underline,
                        color: Color(0xffffffff),
                        decorationColor: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 0 * fem),
                    constraints: BoxConstraints(
                      maxWidth: 321 * fem,
                    ),
                    child: Text(
                      description,
                      //'Venez découvrir ce magnifique et sublime \njoyau de la culture du Douaisis. Soyez prêts \nà être transporter dans le monde du nord \navec ses joies et ses pleurs.',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Text(
                    "Tarif: ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    'tarif de la prestation',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Text(
                    "Places restantes : ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    numberOfRemainingEntries,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Text(
                    "+ d'infos : ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    'si besoin',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Text(
                    "Mail : ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      decoration: TextDecoration.underline,
                      color: Color(0xff000000),
                      decorationColor: Color(0xff000000),
                    ), // Taille de police
                  ),
                  Text(
                    'si besoin',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000), // Taille de police
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupcwp6BwL (MWaGd3hmfEdeaT9ZnAcWp6)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
              padding:
                  EdgeInsets.fromLTRB(10 * fem, 4 * fem, 4 * fem, 10 * fem),
              width: 343 * fem,
              decoration: BoxDecoration(
                color: Color(0xff0eb214),
                borderRadius: BorderRadius.circular(10 * fem),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // notesUQe (10:116)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                    child: Text(
                      'Notes :',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        decoration: TextDecoration.underline,
                        color: Color(0xffffffff),
                        decorationColor: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Container(
                    // sivousavezdesdifficultspourvou (10:117)
                    margin:
                        EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 0 * fem),
                    constraints: BoxConstraints(
                      maxWidth: 328 * fem,
                    ),
                    child: Text(
                      'Si vous avez des difficultés  pour vous \ndéplacer, un service gratuit de navette est  à \nvotre disposition pour vous amener au club\n(su présentation d’un certificat médical).',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupzddpPg2 (MWaGknys3ur8kr4QdmZddp)
              margin: EdgeInsets.fromLTRB(82 * fem, 0 * fem, 84 * fem, 6 * fem),
              width: double.infinity,
              height: 51 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff000000)),
                color: Color(0xfffff400),
                borderRadius: BorderRadius.circular(15 * fem),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    offset: Offset(0 * fem, 4 * fem),
                    blurRadius: 2 * fem,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'S’INSCRIRE',
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2125 * ffem / fem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Container(
              // cliquezdessuspourvousinscrireo (10:118)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0 * fem),
              child: Text(
                'Cliquez dessus pour vous inscrire',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 17 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * ffem / fem,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff564b4b),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
