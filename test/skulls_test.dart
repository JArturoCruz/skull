import 'package:test/test.dart';
import '../bin/skulls.dart';

Carta c(Tipo arriba, Tipo abajo) => Carta(arriba, abajo);
Carta vacia() => Carta(Tipo.Vacio, Tipo.Vacio);

void main() {
  group('Pruebas de Lógica de Puntuación (Skulls of Sedlec)', () {

    
    test('1. Tablero Vacío: Debe sumar 0', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('2. Solo Campesinos: Debe sumar 0 (Sin Reyes no hay puntos)', () {
      var piramide = [
        [c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino)],
        [vacia(), vacia(), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });


    test('3. NIVEL BASE (Pos 1-4) - Rey Abajo (Suelo)', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Campesino, Tipo.Rey), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('4. NIVEL BASE (Pos 1-4) - Rey Arriba', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Rey, Tipo.Campesino), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(1));
    });

    test('5. NIVEL MEDIO (Pos 5-7) - Rey Abajo', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Campesino, Tipo.Rey), vacia(), vacia()], // Rey aquí
        [c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino)]
      ];
      expect(calcularPuntaje(piramide), equals(8));
    });

    test('6. NIVEL MEDIO (Pos 5-7) - Rey Arriba', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Rey, Tipo.Campesino), vacia(), vacia()], 
        [c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(5));
    });

    test('7. NIVEL CIMA (Pos 8-9) - Rey Arriba (El gran observador)', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Campesino, Tipo.Campesino), vacia(), vacia()],
        [c(Tipo.Campesino, Tipo.Campesino), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(4));
    });

    test('8. Cascada Vertical (Torre)', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Campesino), vacia()],
        [c(Tipo.Rey, Tipo.Campesino), vacia(), vacia()],
        [c(Tipo.Rey, Tipo.Campesino), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(9));
    });

    test('9. Tablero Lleno de Reyes (Estrés Máximo)', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)]
      ];
      expect(calcularPuntaje(piramide), equals(133));
    });
    
    test('10. Huecos intercalados', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino), c(Tipo.Campesino, Tipo.Campesino)]
      ];
      expect(calcularPuntaje(piramide), equals(8));
    });

  });
}