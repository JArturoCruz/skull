enum Tipo { Rey, Campesino, Sacerdote, Criminal, Vacio }

class Carta {
  Tipo arriba;
  Tipo abajo;
  Carta(this.arriba, this.abajo);
}

int calcularPuntaje(List<List<Carta>> piramide) {
  int totalJuego = 0;

  for (int f = 0; f < piramide.length; f++) {
    for (int c = 0; c < piramide[f].length; c++) {
      Carta carta = piramide[f][c];

      // --- 1. REYES (SOLO CAMPESINOS) ---
      if (carta.arriba == Tipo.Rey) {
        // Suma mitad de abajo si es Campesino
        totalJuego += _contarCampesinosEnFila(piramide, f, soloAbajo: true);
        // Suma resto de la pirámide si son Campesinos
        totalJuego += _contarCampesinosResto(piramide, f + 1);
      }
      if (carta.abajo == Tipo.Rey) {
        totalJuego += _contarCampesinosResto(piramide, f + 1);
      }

      // --- 2. CRIMINALES ---
      if (carta.arriba == Tipo.Criminal) {
        if (_tieneVecinoSacerdote(piramide, f, c, 'arriba')) totalJuego += 2;
      }
      if (carta.abajo == Tipo.Criminal) {
        if (_tieneVecinoSacerdote(piramide, f, c, 'abajo')) totalJuego += 2;
      }
    }
  }
  return totalJuego;
}

// --- HELPERS ESTRICTOS PARA REYES ---

int _contarCampesinosResto(List<List<Carta>> piramide, int startRow) {
  int contador = 0;
  for (int i = startRow; i < piramide.length; i++) {
    for (Carta c in piramide[i]) {
      // AQUÍ ESTÁ LA CORRECCIÓN: Usamos '==' en lugar de '!='
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

// --- BUSCADOR DE VECINOS (CRIMINALES) ---

bool _tieneVecinoSacerdote(List<List<Carta>> piramide, int f, int c, String parte) {
  Carta miCarta = piramide[f][c];

  // Interno
  if (parte == 'arriba' && miCarta.abajo == Tipo.Sacerdote) return true;
  if (parte == 'abajo' && miCarta.arriba == Tipo.Sacerdote) return true;

  // Laterales
  if (c > 0) {
    Carta izq = piramide[f][c - 1];
    if (parte == 'arriba' && izq.arriba == Tipo.Sacerdote) return true;
    if (parte == 'abajo' && izq.abajo == Tipo.Sacerdote) return true;
  }
  if (c < piramide[f].length - 1) {
    Carta der = piramide[f][c + 1];
    if (parte == 'arriba' && der.arriba == Tipo.Sacerdote) return true;
    if (parte == 'abajo' && der.abajo == Tipo.Sacerdote) return true;
  }

  // Verticales
  if (parte == 'abajo') {
    int filaSuelo = f + 1;
    if (filaSuelo < piramide.length) {
      if (c < piramide[filaSuelo].length && piramide[filaSuelo][c].arriba == Tipo.Sacerdote) return true;
      if (c + 1 < piramide[filaSuelo].length && piramide[filaSuelo][c + 1].arriba == Tipo.Sacerdote) return true;
    }
  } 
  if (parte == 'arriba') {
    int filaCielo = f - 1;
    if (filaCielo >= 0) {
      if (c - 1 >= 0 && c - 1 < piramide[filaCielo].length) {
        if (piramide[filaCielo][c - 1].abajo == Tipo.Sacerdote) return true;
      }
      if (c < piramide[filaCielo].length) {
        if (piramide[filaCielo][c].abajo == Tipo.Sacerdote) return true;
      }
    }
  }
  return false;
}