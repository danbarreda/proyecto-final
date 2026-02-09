import 'package:biblioteca_unimet/widgets/loginForm.dart';
import 'package:biblioteca_unimet/widgets/barraSuperior.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const MISION = "Permitir el acceso de recursos\neducativos a cualquier usuario  de la\nUniversidad Metropolitana, que\noptimice y asegure el proceso de\nintercambio, venta, alquiler y\nvisualización de material. Se busca\nincrementar el conocimiento por\nmedios más amigables y estrechar la\ncolaboración entre los usuarios .";
const VISION = "Generar una nueva plataforma digital\ncolaborativa que aportará \nconocimientos dentro de la Unimet, \nformando una cultura universitaria de \nsolidaridad y reutilización de \nrecursos.  Y además ser  lograr la \neliminación de barreras de acceso a \ninformación.";

const MISION1= "Permitir el acceso de recursos educativos a cualquier usuario  de la Universidad Metropolitana, que optimice y asegure el proceso de intercambio, venta, alquiler y visualización de material. Se busca incrementar el conocimiento por medios más amigables y estrechar la colaboración entre los usuarios .";
const VISION1 = "Generar una nueva plataforma digital colaborativa que aportará conocimientos dentro de la Unimet,  formando una cultura universitaria de solidaridad y reutilización de recursos.  Y además ser  lograr la eliminación de barreras de acceso a información.";
class LandingBodyDesktop extends StatefulWidget {
  const LandingBodyDesktop({super.key});

  @override
  State<LandingBodyDesktop> createState() => _LandingBodyDesktopState();
}

class _LandingBodyDesktopState extends State<LandingBodyDesktop> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          Stack(
            children: [
              Positioned.fill(
              child: Image(
                image: AssetImage("assets/images/homepagebg.png"),
                fit: BoxFit.cover,
              ),
              ),  
              Column(
                spacing: 15,          
                children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text("Bienvenido a SAMANET!", style: GoogleFonts.gasoekOne(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: screenHeight * 0.05
                )),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: LoginForm()),
                ),
                ]
              )
              ],
          ),
          Container(
            color: Colors.indigo[900],
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Text("Ecosistema colaborativo con material vigente y verificado",style: GoogleFonts.museoModerno(color: Colors.white, fontSize: screenWidth*0.03, fontWeight: FontWeight.w600),),
          ),
          Stack(
            children: [
              Positioned.fill(
              child: Image(
                image: AssetImage("assets/images/homepagefig.png"),
                fit: BoxFit.fill,
              ),
              ),  
              Padding(padding: EdgeInsetsGeometry.fromLTRB(15,30, 30 , 30),
                child: Column(
                spacing: 15,          
                children: [
                  Row(
                    children: [
                      Expanded( child:Container(
                        padding: EdgeInsets.fromLTRB(30, 15, 85, 30),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 157, 142, 242),
                          borderRadius: BorderRadius.circular(20)
                         ),
                        child: SizedBox(
                          width: (screenWidth/2) - 25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Nuestra Misión", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 32),),
                            Text(MISION1, textAlign: TextAlign.left, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: screenWidth*0.016))
                          ]                       
                          )),
                      )),
                      Transform.translate(offset: Offset(-85,0),
                        child: SizedBox(
                        width: (screenWidth/2) - 45,
                        child: Image(
                        image: AssetImage("assets/images/mision1.png"),
                        fit: BoxFit.scaleDown,
                      ))),
                    ],
                  ),
                  //vision
                  Row(
                    children: [
                      Transform.translate(offset: Offset(95, 0), child:SizedBox(
                        width: (screenWidth/2) - 45,
                        child: Image(
                        image: AssetImage("assets/images/vision1.png"),
                        fit: BoxFit.scaleDown,
                      ))),
                      Expanded(child:Container(
                        padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                          color: Color.fromARGB(255, 157, 142, 242),
                          borderRadius: BorderRadius.circular(20)
                         ),
                        child: SizedBox(
                          width: (screenWidth/2) - 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                            Text("Visión", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 32),),
                            Text(VISION1, textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: screenWidth*0.016))
                          ]                       
                          ),)
                      ))
                    ],
                  ),

                ]
              ))
              ],
          ),
          Container(color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(spacing: 5, mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center,children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end ,spacing: 12,children:[Image(image: AssetImage("assets/images/logounimet.png",), height: 80,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Universidad Metropolitana", textAlign: TextAlign.left,style: GoogleFonts.crimsonText(color: Colors.deepOrange.shade400, fontWeight: FontWeight.w700, fontSize: screenWidth*0.025)),
                    Text("Biblioteca Pedro Grases", textAlign: TextAlign.left ,style: GoogleFonts.crimsonText(color: Colors.deepOrange.shade400, fontWeight: FontWeight.w300, fontSize: screenWidth*0.020))
                    
                    ]
                  ),]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
                    Text("Plataforma", style: GoogleFonts.inter(fontWeight: FontWeight.bold),)
                    //aqui iremos agregando los links que correspondan a cada columna por si acaso
                  ],
                  ),
                  Column(children: [
                    Text("Funciones", style: GoogleFonts.inter(fontWeight: FontWeight.bold),)
                  ],
                  ),
                  Column(children: [
                    Text("Sobre nosotros", style: GoogleFonts.inter(fontWeight: FontWeight.bold),)
                  ],
                  ),
                  Column(children: [
                    Text("Soporte", style: GoogleFonts.inter(fontWeight: FontWeight.bold),)
                  ],
                  ),
                  
                ],
              ),
              Text("Copyright © 2026 - Universidad Metropolitana.", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w800)),
              Text("Todos los derechos reservados", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w800))
            ],),
          )
        ]
      )
    );
  }
}

class LandingBodyMovil extends StatelessWidget {
  const LandingBodyMovil({super.key});

  @override
  Widget build(BuildContext context) {
    
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print("$screenWidth");
    return Stack(
        children: [
          Positioned.fill(
          child: Image(
            image: AssetImage("assets/images/homepagebg.png"),
            fit: BoxFit.cover,
          ),
          ),  
          Column(          
            spacing: 12.5,
            children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text("¡Bienvenido a Samanet!", style: GoogleFonts.museoModerno(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: screenHeight * 0.05
            )),
            ),
            Center(child: LoginForm()),
            Expanded(child: 
              Column(children: [
                Container(
                  color: Colors.indigo[900],
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text("Ecosistema colaborativo con\n material vigente y verificado",style: GoogleFonts.museoModerno(color: Colors.white, fontSize: screenWidth*0.053, fontWeight: FontWeight.w600),),
                ),
                Expanded(child: 
                  Container(color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Column(spacing: 5, mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end,spacing: 12, children: [Image(image: AssetImage("assets/images/logounimet.png",), height: 80), Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Universidad Metropolitana", textAlign: TextAlign.left,style: GoogleFonts.crimsonText(color: Colors.deepOrange.shade400, fontWeight: FontWeight.w700, fontSize: screenWidth*0.045)),Text("Biblioteca Pedro Grases", textAlign: TextAlign.left ,style: GoogleFonts.crimsonText(color: Colors.deepOrange.shade400, fontWeight: FontWeight.w300, fontSize: screenWidth*0.04))])],),
                      Text("Copyright © 2026 - Universidad Metropolitana.", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w800)),
                      Text("Todos los derechos reservados", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w800))
                    ],),
                  )
                )
              ],))
            ]
          )
          ],
      );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {    
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600){
      return Scaffold(
        appBar: BarraSuperiorMovilHome(),
        body: LandingBodyMovil(),
      );
    }else{
      return Scaffold(
        appBar: BarraSuperiorDesktopHome(),
        body: LandingBodyDesktop(),
      );
    }
  }
}

