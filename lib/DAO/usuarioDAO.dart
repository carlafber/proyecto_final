import 'package:proyecto_final/clases/usuario.dart';
import 'package:proyecto_final/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDAO {
  DBHelper db = DBHelper();
  
  Future<List<Usuario>> obtenerUsuarios() async {
    Database database = await db.abrirBD();
    final List<Map<String, dynamic>> mapas = await database.query('usuario');
    return List.generate(mapas.length, (i){
      return Usuario.fromMap(mapas[i]);
    });
  }

  Future<Usuario?> existeUsuario(String numTarjetaIntroducido) async {
    //Obtener la lista de usuarios desde la base de datos
    List<Usuario> usuarios = await obtenerUsuarios();

    for (var usuario in usuarios) {
      if (usuario.numeroTarjeta == numTarjetaIntroducido) {
        // Si el número de tarjeta coincide, devuelve el usuario
        return usuario;
      }
    }

    // Si no se encuentra el usuario con el número de tarjeta, devuelve null
    return null;
  }
}