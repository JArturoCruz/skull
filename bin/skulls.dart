// skulls.dart
enum Tipo { Rey, Campesino, Vacio }

class Carta {
  Tipo arriba;
  Tipo abajo;
  Carta(this.arriba, this.abajo);
}

// --- FUNCIÓN PRINCIPAL DE CÁLCULO ---
int calcularPuntaje(List<List<Carta>> piramide) {
  int totalJuego = 0;

  for (int f = 0; f < piramide.length; f++) {
    for (int c = 0; c < piramide[f].length; c++) {
      Carta carta = piramide[f][c];

      // --- REY EN NIVEL SUPERIOR (Impar) ---
      // Suma la mitad de abajo de su misma carta + todas las filas inferiores
      if (carta.arriba == Tipo.Rey) {
        int puntos = 0;
        puntos += _contarOcupadosEnFila(piramide, f, soloAbajo: true);
        puntos += _contarRestoPiramide(piramide, f + 1);
        totalJuego += puntos;
      }

      // --- REY EN NIVEL INFERIOR (Par) ---
      // Suma solo las filas inferiores (el suelo de su propia fila no cuenta)
      if (carta.abajo == Tipo.Rey) {
        int puntos = 0;
        puntos += _contarRestoPiramide(piramide, f + 1);
        totalJuego += puntos;
      }
    }
  }
  return totalJuego;
}

// --- FUNCIONES AUXILIARES ---

int _contarRestoPiramide(List<List<Carta>> piramide, int startRow) {
  int contador = 0;
  for (int i = startRow; i < piramide.length; i++) {
    for (Carta c in piramide[i]) {
      if (c.arriba != Tipo.Vacio) contador++;
      if (c.abajo != Tipo.Vacio) contador++;
    }
  }
  return contador;
}

int _contarOcupadosEnFila(List<List<Carta>> piramide, int filaIndex, {required bool soloAbajo}) {
  int contador = 0;
  for (Carta c in piramide[filaIndex]) {
    if (soloAbajo) {
      if (c.abajo != Tipo.Vacio) contador++;
    } else {
      if (c.arriba != Tipo.Vacio) contador++;
      if (c.abajo != Tipo.Vacio) contador++;
    }
  }
  return contador;
}