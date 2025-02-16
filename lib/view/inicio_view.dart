import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/model/especialidad_model.dart';
import '/model/profesional_model.dart';
import '/model/usuario_model.dart';
import '/model/cita_model.dart';
import '/viewmodel/inicio_viewmodel.dart';
import '/viewmodel/CRUD/cita_viewmodel.dart';
import '/viewmodel/CRUD/profesional_viewmodel.dart';
import '/viewmodel/estilos_viewmodel.dart';
import '/viewmodel/guardar_usuario_viewmodel.dart';
import '/viewmodel/provider_idioma_viewmodel.dart';

class InicioApp extends StatefulWidget {
  const InicioApp({super.key});

  @override
  State<InicioApp> createState() => Inicio();
}

class Inicio extends State<InicioApp> {
  ProfesionalCRUD profesionalCRUD = ProfesionalCRUD();
  CitaCRUD citaCRUD = CitaCRUD();
  InicioViewModel iniciovm = InicioViewModel();
  Guardar guardar = Guardar();

  List<Cita> citas = [];
  Map<int, Especialidad> especialidades = {};
  Map<int, String> nombresProfesionales = {};
  String color = "";


  @override
  void initState() {
    super.initState();
    Usuario? usuario = guardar.get();
    if (usuario != null) {
      _cargarCitas(usuario.idUsuario as int);
    }
  }

  Future<void> _cargarCitas(int idUsuario) async {
    List<Cita> lista = await citaCRUD.obtenerCitasProximasUsuario(idUsuario);
    setState(() {
      citas = lista;
    });

    // Ordenar las citas por fecha
    citas.sort((a, b) {
      DateTime fechaA = DateTime.parse(a.fecha); // Convertir la fecha de la cita 'a' a DateTime
      DateTime fechaB = DateTime.parse(b.fecha); // Convertir la fecha de la cita 'b' a DateTime
      return fechaA.compareTo(fechaB); // Ordenar de más antiguo a más reciente
    });

    // Cargar especialidades para cada profesional
    await Future.forEach(citas, (cita) async {
      Especialidad? especialidad = await profesionalCRUD.obtenerEspecialidadDeProfesional(cita.idProfesional);
      Profesional? profesional = await profesionalCRUD.obtenerProfesional(cita.idProfesional);
      
      if (especialidad != null) {
        setState(() {
          especialidades[cita.idProfesional] = especialidad;
        });
      }
      
      if (profesional != null) {
        setState(() {
          nombresProfesionales[cita.idProfesional] = profesional.nombreProfesional;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final idiomaProvider = Provider.of<ProviderIdioma>(context);
    final List<String> idiomas = ['es', 'en'];

    return Scaffold(
      backgroundColor: Estilos.dorado,
      endDrawer: Drawer(
        child: Container(
          color: Estilos.dorado_oscuro,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding (padding: const EdgeInsets.all(40)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/perfil');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Estilos.dorado_claro),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 30),
                      const Padding(padding: EdgeInsets.only(right: 20)),
                      Text(
                        AppLocalizations.of(context)!.menuPerfil, 
                        style: Estilos.texto3,
                      ),
                    ],
                  ),
                ),
              ),
              Padding (padding: const EdgeInsets.all(60)),
              GestureDetector(
                onTap: () {
                  Usuario? u = guardar.get();
                  iniciovm.abrirPDF(context, u!.compania);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Estilos.dorado_claro),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.bookOpen, color: Colors.white),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      Text(
                        AppLocalizations.of(context)!.menuCuadroMedico, 
                        style: Estilos.texto3,
                      ),
                    ],
                  ),
                ),
              ),
              Padding (padding: const EdgeInsets.all(60)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Estilos.dorado_claro),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.globe, color: Colors.white),
                    const Padding(padding: EdgeInsets.only(right: 20)),
                    DropdownButton<String>(
                      value: idiomaProvider.idioma.languageCode,
                      items: idiomas.map((String idioma) {
                        return DropdownMenuItem(
                          value: idioma,
                          child: Text(idioma == 'es' ? 'Español' : 'English'),
                        );
                      }).toList(),
                      onChanged: (String? nuevoIdioma) {
                        if (nuevoIdioma != null) {
                          idiomaProvider.cambiarIdioma(nuevoIdioma);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Estilos.dorado_oscuro,  // Fondo del Dropdown
                      style: Estilos.texto3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Fila con los dos botones en la parte superior
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuir los botones de manera adecuada
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inicio_sesion');
                    },
                    backgroundColor: Estilos.dorado_oscuro,
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.tituloProximasCitas, 
                      style: Estilos.titulo2,
                      textAlign: TextAlign.center,  // Centra el texto
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return FloatingActionButton(
                        onPressed: () {
                          // Abrir el Drawer desde el lado derecho con el contexto
                          Scaffold.of(context).openEndDrawer();
                        },
                        backgroundColor: Estilos.dorado_oscuro,
                        child: const Icon(FontAwesomeIcons.bars, color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
              child: Container(
                color: Estilos.fondo,
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (context, index) {

                    Cita cita = citas[index];
                    String nombreEspecialidad = especialidades[cita.idProfesional]?.nombreEspecialidad ?? 'Desconocida';
                    String color = especialidades[cita.idProfesional]?.color ?? '0xFFFFFFFF';
                    String nombreProfesional = nombresProfesionales[cita.idProfesional] ?? 'Desconocido';
                    String fechaFormateada = DateFormat.yMMMMd("es_ES").format(DateFormat('yyyy-MM-dd').parse(cita.fecha));
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/ver_cita',
                          arguments: cita,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(int.parse(color)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.stethoscope, color: Colors.black),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                '${AppLocalizations.of(context)!.textoCita} $nombreEspecialidad ${AppLocalizations.of(context)!.textoCitaCon} $nombreProfesional. ${AppLocalizations.of(context)!.textoCitaEl} $fechaFormateada ${AppLocalizations.of(context)!.textoCitaALas} ${cita.hora}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/ver_cita',
                                  arguments: cita,
                                );
                              },
                              icon: const Icon(FontAwesomeIcons.circleInfo, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
