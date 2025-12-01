import 'dart:io';
import 'skulls.dart';

void main() {
  List<List<Carta>> piramide = _inicializarTableroVacio();
  
  print('=== SKULLS OF SEDLEC: REGLAS ESTRICTAS ===');
  print('Reyes solo suman Campesinos. Criminales (K) suman con Sacerdotes (S).');

  bool continuar = true;

  while (continuar) {
    _imprimirTableroNumerado(piramide);
    
    print('\nOPCIONES:');
    print(' [1] Colocar Carta (Posición 1-9)');
    print(' [T] Terminar y Calcular');
    
    String opcion = _leerTexto('Selecciona:').toUpperCase();

    if (opcion == 'T') {
      continuar = false;
    } else if (opcion == '1') {
      _gestionarTurno(piramide);
    } else {
      print('Opción no válida.');
    }
  }

  print('\n=== RESULTADO FINAL ===');
  _imprimirTableroNumerado(piramide);
  int puntaje = calcularPuntaje(piramide);
  print('\n>>> PUNTUACIÓN TOTAL: $puntaje <<<');
}

void _gestionarTurno(List<List<Carta>> piramide) {
  int pos = _leerEntero('\n¿En qué posición (1-9) colocarás la carta?');
  
  if (pos < 1 || pos > 9) {
    print('Error: Posición inválida (1-9).');
    return;
  }

  var coords = _traducirPosicion(pos);
  int f = coords['f']!;
  int c = coords['c']!;

  print('>> Editando Posición $pos');
  print('>> Tipos: R=Rey, C=Campesino, S=Sacerdote, K=Criminal, V=Vacio');
  
  piramide[f][c].arriba = _pedirTipo('   ¿Qué va ARRIBA?');
  piramide[f][c].abajo = _pedirTipo('   ¿Qué va ABAJO? ');
  
  print('>> Carta colocada.');
}

void _imprimirTableroNumerado(List<List<Carta>> piramide) {
  print('\n--- TABLERO ---');
  String fila0 = '       8:[${_s(piramide[0][0])}] 9:[${_s(piramide[0][1])}]';
  String fila1 = '    5:[${_s(piramide[1][0])}] 6:[${_s(piramide[1][1])}] 7:[${_s(piramide[1][2])}]';
  String fila2 = ' 1:[${_s(piramide[2][0])}] 2:[${_s(piramide[2][1])}] 3:[${_s(piramide[2][2])}] 4:[${_s(piramide[2][3])}]';

  print(fila0);
  print(fila1);
  print(fila2);
}

String _s(Carta c) {
  return '${_letra(c.arriba)}|${_letra(c.abajo)}';
}

String _letra(Tipo t) {
  switch (t) {
    case Tipo.Rey: return 'R';
    case Tipo.Campesino: return 'C';
    case Tipo.Sacerdote: return 'S';
    case Tipo.Criminal: return 'K';
    case Tipo.Vacio: return ' ';
  }
}

Map<String, int> _traducirPosicion(int pos) {
  if (pos >= 8) return {'f': 0, 'c': pos - 8};
  if (pos >= 5) return {'f': 1, 'c': pos - 5};
  return {'f': 2, 'c': pos - 1};
}

Tipo _pedirTipo(String mensaje) {
  while (true) {
    String input = _leerTexto(mensaje).toUpperCase();
    if (input == 'R') return Tipo.Rey;
    if (input == 'C') return Tipo.Campesino;
    if (input == 'S') return Tipo.Sacerdote;
    if (input == 'K') return Tipo.Criminal;
    if (input == 'V') return Tipo.Vacio;
    print('Error. Usa: R, C, S, K, V');
  }
}

int _leerEntero(String m) {
  while(true) {
    stdout.write('$m ');
    int? v = int.tryParse(stdin.readLineSync() ?? '');
    if(v != null) return v;
  }
}

String _leerTexto(String m) {
  stdout.write('$m ');
  return stdin.readLineSync()?.trim() ?? '';
}

List<List<Carta>> _inicializarTableroVacio() {
  return [
    [Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio)], 
    [Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio)], 
    [Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio), Carta(Tipo.Vacio, Tipo.Vacio)] 
  ];
}