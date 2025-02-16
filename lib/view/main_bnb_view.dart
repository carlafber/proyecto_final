import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'inicio_view.dart';
import 'estadisticas_view.dart';
import 'calendario_view.dart';
import 'nueva_cita_view.dart';
import '/viewmodel/estilos_viewmodel.dart';



class MainBnBApp extends StatefulWidget {
  const MainBnBApp({super.key});

  @override
  State<MainBnBApp> createState() => MainBnB();
}


class MainBnB extends State<MainBnBApp> {
  int _indiceSeleccionado = 0;

  static const List<Widget> _clases = <Widget>[
    InicioApp(),
    NuevaCitaApp(),
    EstadisticasApp(),
    CalendarioApp(),
  ];


  // Función para manejar la selección del item seleccionado
  void _onItemTapped(int indice) {
    setState(() {
      _indiceSeleccionado = indice;  // Actualiza el indice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _clases.elementAt(_indiceSeleccionado),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Estilos.fondo,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
              color: _indiceSeleccionado == 0 ? Estilos.dorado_oscuro : Colors.black,
            ),
            label: AppLocalizations.of(context)!.labelInicio,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.circlePlus,
              color: _indiceSeleccionado == 1 ? Estilos.dorado_oscuro : Colors.black,
            ),
            label: AppLocalizations.of(context)!.labelNueva,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.chartSimple,
              color: _indiceSeleccionado == 2 ? Estilos.dorado_oscuro : Colors.black,
            ),
            label: AppLocalizations.of(context)!.labelEstadisticas,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.solidCalendarDays,
              color: _indiceSeleccionado == 3 ? Estilos.dorado_oscuro : Colors.black,
            ),
            label: AppLocalizations.of(context)!.labelCalendario,
          ),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Estilos.dorado_oscuro,  // Color para el ítem seleccionado
        onTap: _onItemTapped, // La función para manejar el tap
      ),
    );
  }
}