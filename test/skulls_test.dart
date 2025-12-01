import 'package:test/test.dart';
import '../bin/skulls.dart'; 

Carta c(Tipo a, Tipo b) => Carta(a, b);
Carta vacia() => Carta(Tipo.Vacio, Tipo.Vacio);

void main() {
  group('Lógica de Reyes (Solo Campesinos)', () {

    test('01. Rey con Campesinos: Suma correctamente', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Campesino, Tipo.Campesino), vacia(), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(2));
    });

    test('02. Rey con Sacerdotes y Criminales (SIN pareja): Suma 0', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Sacerdote, Tipo.Sacerdote), vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Sacerdote), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('03. Rey con otros Reyes: Suma 0 (Ignorados)', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('04. Rey Mixto (Solo cuenta al Campesino)', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Campesino, Tipo.Sacerdote), vacia(), vacia()], 
        [c(Tipo.Criminal, Tipo.Rey), vacia(), vacia(), vacia()] 
      ];
      expect(calcularPuntaje(piramide), equals(3));
    });
  });

  group('Lógica de Criminales y Sacerdotes', () {
    
    test('05. Criminal sin Sacerdotes: 0 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), c(Tipo.Criminal, Tipo.Vacio), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('06. Criminal y Sacerdote pegados: 2 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Criminal, Tipo.Sacerdote), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(2));
    });

    test('07. Criminal rodeado de Sacerdotes: Solo 2 pts (No acumula)', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Criminal), c(Tipo.Vacio, Tipo.Sacerdote), vacia()],
        [c(Tipo.Sacerdote, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(2));
    });
    test('07. Criminal rodeado de Sacerdotes: Solo 2 pts (No acumula)', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Vacio), c(Tipo.Vacio, Tipo.Criminal), vacia()],
        [c(Tipo.Vacio, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });
     test('07. Criminal rodeado de Sacerdotes: Solo 2 pts (No acumula)', () {
      var piramide = [
        [c(Tipo.Vacio,Tipo.Criminal), vacia()],
        [c(Tipo.Sacerdote, Tipo.Criminal), c(Tipo.Criminal, Tipo.Criminal), vacia()],
        [c(Tipo.Vacio, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });
  });

  group('Integración Completa', () {
    test('08. Tablero Mixto: Rey ignora Criminales, Criminal puntúa con Sacerdote', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        // Criminal (ve Sacerdote -> +2) | Campesino (Rey lo ve -> +1)
        [c(Tipo.Criminal, Tipo.Sacerdote), c(Tipo.Campesino, Tipo.Vacio), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      // Total esperado: 1 (del Rey) + 2 (del Criminal) = 3
      expect(calcularPuntaje(piramide), equals(3));
    });
  });

  group('Validación de Coordenadas 1-9', () {
    Map<String, int> traducir(int pos) {
      if (pos >= 8) return {'f': 0, 'c': pos - 8};
      if (pos >= 5) return {'f': 1, 'c': pos - 5};
      return {'f': 2, 'c': pos - 1};
    }

    test('09. Mapeo Correcto', () {
      expect(traducir(1)['f'], equals(2));
      expect(traducir(5)['f'], equals(1));
      expect(traducir(9)['f'], equals(0));
    });
  });
}