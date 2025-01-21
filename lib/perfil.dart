import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_final/DAO/usuarioDAO.dart';
import 'clases/usuario.dart';
import 'estilos.dart';
import 'guardar.dart';

class PerfilApp extends StatefulWidget {
  const PerfilApp({super.key});

  @override
  State<PerfilApp> createState() => _PerfilApp();
}

class _PerfilApp extends State<PerfilApp> {
  Guardar guardar = Guardar();
  UsuarioDAO usuarioDAO = UsuarioDAO();
  
  @override
  Widget build(BuildContext context) {
    Usuario? usuario = guardar.get();

    return Scaffold(
      backgroundColor: Estilos.dorado,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Estilos.dorado_oscuro,
                        child: const Icon(Icons.arrow_back, color: Colors.white)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/perfil.png', width: 100, height: 100),
                      const Padding(padding: EdgeInsets.all(10)),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'DETALLES DEL PERFIL',
                          textAlign: TextAlign.center,
                          style: Estilos.titulo2,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(30)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.user, color: Colors.black),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            'Nombre:',
                            style: Estilos.texto,
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Text(
                            usuario!.nombre,
                            style: Estilos.texto,
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.envelope, color: Colors.black),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            'Correo:',
                            style: Estilos.texto,
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Text(
                            usuario.correo,
                            style: Estilos.texto,
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.creditCard, color: Colors.black),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            'Número de tarjeta:',
                            style: Estilos.texto,
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Text(
                            usuario.numeroTarjeta,
                            style: Estilos.texto,
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.circleCheck, color: Colors.black),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            'Compañía:',
                            style: Estilos.texto,
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Text(
                            usuario.compania,
                            style: Estilos.texto,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //pedir confirmación
                          bool? confirmacion = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmar eliminación"),
                                content: Text("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
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
                            await usuarioDAO.eliminarUsuario(usuario.idUsuario as int);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usuario eliminado correctamente")),
                            );
                            await Navigator.pushNamed(context, '/inicio_sesion');
                          }
                        },
                        child: Container(
                          height: 75,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Estilos.dorado_claro,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            'Eliminar cuenta',
                            textAlign: TextAlign.center,
                            style: Estilos.texto3,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(30)),
                      GestureDetector(
                        onTap: () async {
                          //funcion que abra un dialogo en el que tiene que meter la contraseña actual y dos veces la nueva, 
                          //si la actual esta bien y las nuevas coinciden -> se cambia la contraseña
                          _actualizarContrasena(context, usuario, usuarioDAO);
                        },
                        child: Container(
                          height: 75,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Estilos.dorado_claro,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            'Actualizar contraseña',
                            textAlign: TextAlign.center,
                            style: Estilos.texto3,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }


  void _actualizarContrasena(BuildContext context, Usuario usuario, UsuarioDAO usuarioDAO) {
    final formulario = GlobalKey<FormState>();
    final TextEditingController contrasenaActual = TextEditingController();
    final TextEditingController contrasenaNueva1 = TextEditingController();
    final TextEditingController contrasenaNueva2 = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Actualiza la contraseña", style: Estilos.texto5),
          backgroundColor: Estilos.fondo,
          content: SizedBox(
            width: 400,
            child: Form(
              key: formulario,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
                    controller: contrasenaActual,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Contraseña actual",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Estilos.dorado_oscuro,
                        ),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      }
                      if(usuario.contrasena != value){
                        return "Contraseña incorrecta";
                      }
                      return null; 
                    }
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    controller: contrasenaNueva1,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Nueva contraseña",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Estilos.dorado_oscuro,
                        ),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      } else if (value.length < 6) {
                        return "Debe tener al menos 6 caracteres";
                      }
                      return null; 
                    }
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    controller: contrasenaNueva2,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirmar contraseña",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Estilos.dorado_oscuro,
                        ),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      } else if (value.length < 6) {
                        return "Debe tener al menos 6 caracteres";
                      }
                      if(contrasenaNueva1 != contrasenaNueva2){
                        return "Las contraseñas no coinciden";
                      }
                      return null; 
                    }
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: Estilos.texto4),
            ),
            ElevatedButton(
              onPressed: () {
                if (formulario.currentState!.validate()) {
                  usuarioDAO.actualizarContrasena(usuario.idUsuario, contrasenaNueva1);
                  Navigator.pop(context);
                }
              },
              child: Text("Guardar", style: Estilos.texto4),
            ),
          ],
        );
      },
    );
  }
}