import 'dart:io';
import 'skulls.dart';

void main() {
  List<List<Carta>> piramide = _inicializarTableroVacio();
  
  print('=== SKULLS OF SEDLEC: ULTIMATE EDITION ===');
  print('Roles: (R)ey, (C)ampesino, (S)acerdote, (K)riminal, (E)namorado.');

  bool continuar = true;

  while (continuar) {
    _imprimirTableroNumerado(piramide);
    
    print('\nOPCIONES:');
    print(' [1] Colocar Carta');
    print(' [T] Terminar');
    
    String opcion = _leerTexto('Selecciona:').toUpperCase();

    if (opcion == 'T') {
      continuar = false;
    } else if (opcion == '1') {
      _gestionarTurno(piramide);
    }
  }

  print('\n=== RESULTADO FINAL ===');
  _imprimirTableroNumerado(piramide);
  int puntaje = calcularPuntaje(piramide);
  print('\n>>> PUNTUACIÓN TOTAL: $puntaje <<<');
}

void _gestionarTurno(List<List<Carta>> piramide) {
  int pos = _leerEntero('\n¿Posición (1-9)?');
  if (pos < 1 || pos > 9) return;

  var coords = _traducirPosicion(pos);
  int f = coords['f']!;
  int c = coords['c']!;

  print('>> Tipos: R, C, S, K, E (Enamorado), V');
  piramide[f][c].arriba = _pedirTipo('   ¿Arriba?');
  piramide[f][c].abajo = _pedirTipo('   ¿Abajo? ');
}

void _imprimirTableroNumerado(List<List<Carta>> p) {
  print('\n--- TABLERO ---');
  print('       8:[${_s(p[0][0])}] 9:[${_s(p[0][1])}]');
  print('    5:[${_s(p[1][0])}] 6:[${_s(p[1][1])}] 7:[${_s(p[1][2])}]');
  print(' 1:[${_s(p[2][0])}] 2:[${_s(p[2][1])}] 3:[${_s(p[2][2])}] 4:[${_s(p[2][3])}]');
}

String _s(Carta c) => '${_l(c.arriba)}|${_l(c.abajo)}';

String _l(Tipo t) {
  switch (t) {
    case Tipo.Rey: return 'R';
    case Tipo.Campesino: return 'C';
    case Tipo.Sacerdote: return 'S';
    case Tipo.Criminal: return 'K';
    case Tipo.Enamorado: return 'E'; // Nuevo rol
    case Tipo.Vacio: return ' ';
  }
}

// Helpers...
Map<String, int> _traducirPosicion(int pos) {
  if (pos >= 8) return {'f': 0, 'c': pos - 8};
  if (pos >= 5) return {'f': 1, 'c': pos - 5};
  return {'f': 2, 'c': pos - 1};
}

Tipo _pedirTipo(String m) {
  while (true) {
    String i = _leerTexto(m).toUpperCase();
    if (i == 'R') return Tipo.Rey;
    if (i == 'C') return Tipo.Campesino;
    if (i == 'S') return Tipo.Sacerdote;
    if (i == 'K') return Tipo.Criminal;
    if (i == 'E') return Tipo.Enamorado;
    if (i == 'V') return Tipo.Vacio;
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