import 'dart:math';

enum Tipo { Rey, Campesino, Sacerdote, Criminal, Enamorado, Vacio }

class Carta {
  Tipo arriba;
  Tipo abajo;
  Carta(this.arriba, this.abajo);
}

class Coordenada {
  final int f;
  final int c;
  final String parte;
  Coordenada(this.f, this.c, this.parte);
  
  @override
  bool operator ==(Object other) => other is Coordenada && f == other.f && c == other.c && parte == other.parte;
  @override
  int get hashCode => Object.hash(f, c, parte);
}

int calcularPuntaje(List<List<Carta>> piramide) {
  int totalJuego = 0;

  for (int f = 0; f < piramide.length; f++) {
    for (int c = 0; c < piramide[f].length; c++) {
      Carta carta = piramide[f][c];

      // --- REYES ---
      if (carta.arriba == Tipo.Rey) {
        totalJuego += _contarCampesinosEnFila(piramide, f, soloAbajo: true);
        totalJuego += _contarCampesinosResto(piramide, f + 1);
      }
      if (carta.abajo == Tipo.Rey) {
        totalJuego += _contarCampesinosResto(piramide, f + 1);
      }

      // --- CRIMINALES ---
      if (carta.arriba == Tipo.Criminal) {
        if (_tieneVecinoTipo(piramide, f, c, 'arriba', Tipo.Sacerdote)) totalJuego += 2;
      }
      if (carta.abajo == Tipo.Criminal) {
        if (_tieneVecinoTipo(piramide, f, c, 'abajo', Tipo.Sacerdote)) totalJuego += 2;
      }
    }
  }

  // --- ENAMORADOS ---
  totalJuego += _calcularPuntajeEnamorados(piramide);

  return totalJuego;
}

// --- LOGICA ENAMORADOS ---
int _calcularPuntajeEnamorados(List<List<Carta>> piramide) {
  List<Coordenada> solteros = [];
  for (int f = 0; f < piramide.length; f++) {
    for (int c = 0; c < piramide[f].length; c++) {
      if (piramide[f][c].arriba == Tipo.Enamorado) solteros.add(Coordenada(f, c, 'arriba'));
      if (piramide[f][c].abajo == Tipo.Enamorado) solteros.add(Coordenada(f, c, 'abajo'));
    }
  }
  
  int maxParejas = _buscarMaximoParejas(piramide, solteros, 0, {});
  return maxParejas * 6; 
}

int _buscarMaximoParejas(List<List<Carta>> piramide, List<Coordenada> personas, int indice, Set<int> emparejados) {
  if (indice >= personas.length) return 0;

  if (emparejados.contains(indice)) {
    return _buscarMaximoParejas(piramide, personas, indice + 1, emparejados);
  }

  int mejorResultado = _buscarMaximoParejas(piramide, personas, indice + 1, emparejados);

  Coordenada yo = personas[indice];

  for (int j = indice + 1; j < personas.length; j++) {
    if (!emparejados.contains(j)) {
      Coordenada candidato = personas[j];
      
      if (_sonVecinos(piramide, yo, candidato)) {
        Set<int> nuevosEmparejados = Set.from(emparejados);
        nuevosEmparejados.add(indice);
        nuevosEmparejados.add(j);

        int resultado = 1 + _buscarMaximoParejas(piramide, personas, indice + 1, nuevosEmparejados);
        mejorResultado = max(mejorResultado, resultado);
      }
    }
  }

  return mejorResultado;
}

// --- SISTEMA DE VECINDAD ---
bool _sonVecinos(List<List<Carta>> piramide, Coordenada a, Coordenada b) {
  // 1. Misma carta
  if (a.f == b.f && a.c == b.c) return true;

  // 2. Lateral (Misma fila) - CORREGIDO
  if (a.f == b.f) {
    if ((a.c - b.c).abs() == 1) {
      // Para ser vecinos laterales, deben estar en el mismo nivel (arriba-arriba o abajo-abajo)
      return a.parte == b.parte;
    }
  }

  // 3. Vertical (Soporte)
  Coordenada arriba = (a.f < b.f || (a.f == b.f && a.parte == 'arriba')) ? a : b;
  Coordenada abajo = (arriba == a) ? b : a;

  if (a.parte == 'abajo' && b.parte == 'arriba' && b.f == a.f + 1) {
    if (b.c == a.c || b.c == a.c + 1) return true;
  }
  if (b.parte == 'abajo' && a.parte == 'arriba' && a.f == b.f + 1) {
    if (a.c == b.c || a.c == b.c + 1) return true;
  }
  
  return false;
}

bool _tieneVecinoTipo(List<List<Carta>> piramide, int f, int c, String parte, Tipo objetivo) {
  Coordenada yo = Coordenada(f, c, parte);
  
  for (int ff = 0; ff < piramide.length; ff++) {
    for (int cc = 0; cc < piramide[ff].length; cc++) {
      if (piramide[ff][cc].arriba == objetivo) {
        if (_sonVecinos(piramide, yo, Coordenada(ff, cc, 'arriba'))) return true;
      }
      if (piramide[ff][cc].abajo == objetivo) {
        if (_sonVecinos(piramide, yo, Coordenada(ff, cc, 'abajo'))) return true;
      }
    }
  }
  return false;
}

// --- HELPERS REYES ---
int _contarCampesinosResto(List<List<Carta>> piramide, int startRow) {
  int contador = 0;
  for (int i = startRow; i < piramide.length; i++) {
    for (Carta c in piramide[i]) {
      if (c.arriba == Tipo.Campesino) contador++;
      if (c.abajo == Tipo.Campesino) contador++;
    }
  }
  return contador;
}

int _contarCampesinosEnFila(List<List<Carta>> piramide, int filaIndex, {required bool soloAbajo}) {
  int contador = 0;
  for (Carta c in piramide[filaIndex]) {
    if (soloAbajo) {
      if (c.abajo == Tipo.Campesino) contador++;
    } else {
      if (c.arriba == Tipo.Campesino) contador++;
      if (c.abajo == Tipo.Campesino) contador++;
    }
  }
  return contador;
}