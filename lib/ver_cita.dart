import 'package:flutter/material.dart';
import 'package:proyecto_final/DAO/citaDAO.dart';
import 'DAO/centro_medicoDAO.dart';
import 'DAO/especialidadDAO.dart';
import 'DAO/profesionalDAO.dart';
import 'clases/centro_medico.dart';
import 'clases/cita.dart';
import 'clases/especialidad.dart';
import 'clases/profesional.dart';
import 'db_helper.dart';
import 'estilos.dart';

class VerCitaApp extends StatefulWidget {
  const VerCitaApp({super.key});

  @override
  State<VerCitaApp> createState() => _VerCitaApp();
}

class _VerCitaApp extends State<VerCitaApp> {
  final DBHelper db = DBHelper();
  final EspecialidadDAO especialidadDAO = EspecialidadDAO();
  final ProfesionalDAO profesionalDAO = ProfesionalDAO();
  final CentroMedicoDAO centroDAO = CentroMedicoDAO();
  final CitaDAO citaDAO = CitaDAO();

  Future<String> obtenerDetallesCita(Cita cita) async {
    return 'Fecha: ${cita.fecha}\nHora: ${cita.hora}';
  }

  List<Especialidad> especialidades = [];
  List<Profesional> profesionales = [];
  List<CentroMedico> centros = [];

  Especialidad? especialidadSeleccionada;
  Profesional? profesionalSeleccionado;
  CentroMedico? centroSeleccionado;
  

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final Cita cita = ModalRoute.of(context)!.settings.arguments as Cita;
      await _cargarEspecialidades();
      await _cargarEspecialidadDeCita(cita);
      await _cargarProfesionalDeCita(cita);
      await _cargarCentroDeCita(cita);
    });
  }

  Future<void> _cargarEspecialidades() async {
    List<Especialidad> lista = await especialidadDAO.obtenerEspecialidades();
    setState(() {
      especialidades = lista;
    });
  }

  Future<void> _cargarProfesionales(int idEspecialidad) async {
    List<Profesional> lista = await profesionalDAO.obtenerProfesionalesPorEspecialidad(idEspecialidad);
    setState(() {
      profesionales = lista;
      profesionalSeleccionado = null; // Reinicia selección al cambiar la especialidad
    });
  }


  Future<void> _cargarCentros(int idEspecialidad) async {
    List<CentroMedico> lista = await centroDAO.obtenerCentrosPorEspecialidad(idEspecialidad);
    setState(() {
      centros = lista;
    });
  }

  Future<void> _cargarEspecialidadDeCita(Cita cita) async {
    final especialidad = await profesionalDAO.obtenerEspecialidadDeProfesional(cita.idProfesional);
    if (especialidad != null) {
      setState(() {
        // Busca en la lista la especialidad que coincida con el ID
        especialidadSeleccionada = especialidades.firstWhere(
          (e) => e.idEspecialidad == especialidad.idEspecialidad,
          orElse: () => especialidad, // Usa la especialidad obtenida si no está en la lista
        );
      });
    }
  }

  Future<void> _cargarProfesionalDeCita(Cita cita) async {
    final profesional = await profesionalDAO.obtenerProfesional(cita.idProfesional);
    if (profesional != null) {
      await _cargarProfesionales(profesional.idEspecialidad);
      setState(() {
        // Busca en la lista la especialidad que coincida con el ID
        profesionalSeleccionado = profesionales.firstWhere(
          (e) => e.idProfesional == profesional.idProfesional,
          orElse: () => profesional, // Usa la especialidad obtenida si no está en la lista
        );
      });
    }
  }

  Future<void> _cargarCentroDeCita(Cita cita) async {
    final centro = await centroDAO.obtenerCentro(cita.idCentro);
    if (centro != null) {
      await _cargarCentros(centro.idEspecialidad);
      setState(() {
        // Busca en la lista la especialidad que coincida con el ID
        centroSeleccionado = centros.firstWhere(
          (e) => e.idCentro == centro.idCentro,
          orElse: () => centro, // Usa la especialidad obtenida si no está en la lista
        );
      });
    }
  }
  

  
  @override
  Widget build(BuildContext context) {
    final Cita cita = ModalRoute.of(context)!.settings.arguments as Cita;
    
    return Scaffold(
      backgroundColor: Estilos.dorado,
      body: Padding (
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main_bnb');
                  },
                  backgroundColor: Estilos.dorado_oscuro,
                  child: const Icon(Icons.arrow_back, color: Colors.white)
                ),
              ),
            ),
            Text("DETALLES DE LA CITA", style: Estilos.titulo2),
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Estilos.fondo),
              padding: const EdgeInsets.all(10),
              child: DropdownButton<Especialidad>(
                isExpanded: true,
                value: especialidadSeleccionada,
                hint: const Text("Selecciona una Especialidad"),
                onChanged: (Especialidad? nuevaEspecialidad) {
                  setState(() {
                    especialidadSeleccionada = nuevaEspecialidad;
                  });
                  if (nuevaEspecialidad != null) {
                    _cargarProfesionales(nuevaEspecialidad.idEspecialidad as int);
                    _cargarCentros(nuevaEspecialidad.idEspecialidad as int);
                  }
                },
                items: especialidades.map((Especialidad especialidad) {
                  return DropdownMenuItem<Especialidad>(
                    value: especialidad,
                    child: Text(especialidad.nombreEspecialidad),
                  );
                }).toList(),
              )
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Estilos.fondo),
              padding: const EdgeInsets.all(10),
              child: DropdownButton<Profesional>(
                isExpanded: true,
                value: profesionalSeleccionado,
                hint: const Text("Selecciona un Profesional"),
                onChanged: (Profesional? nuevoProfesional) {
                  setState(() {
                    profesionalSeleccionado = nuevoProfesional;
                  });
                },
                items: profesionales.map((Profesional profesional) {
                  return DropdownMenuItem<Profesional>(
                    value: profesional,
                    child: Text(profesional.nombreProfesional),
                  );
                }).toList(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Estilos.fondo),
              padding: const EdgeInsets.all(10),
              child: DropdownButton<CentroMedico>(
                isExpanded: true,
                value: centroSeleccionado,
                hint: const Text("Selecciona un Centro Médico"),
                onChanged: (CentroMedico? nuevoCentro) {
                  setState(() {
                    centroSeleccionado = nuevoCentro;
                  });
                },
                items: centros.map((CentroMedico centro) {
                  return DropdownMenuItem<CentroMedico>(
                    value: centro,
                    child: Text(centro.nombreCentro),
                  );
                }).toList(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(//DETALLES
              child: FutureBuilder<String>(
                future: obtenerDetallesCita(cita),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Estilos.fondo),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      snapshot.data ?? 'Error al cargar detalles',
                      textAlign: TextAlign.center,
                      style: Estilos.texto,
                    ),
                  );
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Align(
              alignment: Alignment.bottomCenter, // Alinea el botón en parte inferior
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print("Actualizar");
                      },
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Estilos.dorado_claro, 
                          //borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          'Actualizar',
                          textAlign: TextAlign.center,
                          style: Estilos.texto3,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        //pedir confirmación
                        bool? confirmacion = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmar eliminación"),
                              content: Text("¿Estás seguro de que deseas eliminar la cita? Esta acción no se puede deshacer."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false); // Cancelar
                                  },
                                  child: Text("Cancelar", style: Estilos.texto4),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true); // Confirmar
                                  },
                                  child: Text("Eliminar", style: Estilos.texto4),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmacion == true) {
                          await citaDAO.eliminarCita(cita.idCita as int);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Cita eliminada correctamente")),
                          );
                          await Navigator.pushNamed(context, '/inicio');
                        }
                      },
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Estilos.dorado_claro,
                          //borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          'Eliminar',
                          textAlign: TextAlign.center,
                          style: Estilos.texto3,
                        ),
                      ),
                    ),
                 ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}