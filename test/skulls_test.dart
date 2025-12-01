import 'package:test/test.dart';
import '../bin/skulls.dart'; 

Carta c(Tipo a, Tipo b) => Carta(a, b);
Carta vacia() => Carta(Tipo.Vacio, Tipo.Vacio);

void main() {
  group('Lógica de Reyes (Solo Campesinos)', () {

    test('Rey con Campesinos: Suma correctamente', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Campesino, Tipo.Campesino), vacia(), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(2));
    });

    test('Rey con Sacerdotes y Criminales SIN pareja: Suma 0', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Sacerdote, Tipo.Sacerdote), vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Sacerdote), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('Rey con otros Reyes: Suma 0 ', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)],
        [c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey), c(Tipo.Rey, Tipo.Rey)]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('Rey Mixto (Solo cuenta al Campesino)', () {
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

    test('Criminal rodeado de Sacerdotes: Solo 2 pts (No acumula)', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Criminal), c(Tipo.Vacio, Tipo.Sacerdote), vacia()],
        [c(Tipo.Sacerdote, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(2));
    });

    test('Criminal y Sacerdote separados en diagonal: 0 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Sacerdote, Tipo.Vacio), c(Tipo.Vacio, Tipo.Criminal), vacia()],
        [c(Tipo.Vacio, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

     test('Múltiples Criminales con Sacerdotes: 6 pts', () {
      var piramide = [
        [c(Tipo.Vacio,Tipo.Criminal), vacia()],
        [c(Tipo.Sacerdote, Tipo.Criminal), c(Tipo.Criminal, Tipo.Criminal), vacia()],
        [c(Tipo.Vacio, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });
  });

  group('ENAMORADOS', () {

    test('Enamorado Solitario', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), c(Tipo.Enamorado, Tipo.Vacio), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('Misma Carta: 6 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Enamorado), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });

    test('Vecinos Laterales: 6 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Vacio), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });

    test('Vecinos Verticales: 6 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Vacio, Tipo.Enamorado), vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Vacio), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });

    test('El TRIÁNGULO AMOROSO solo 1 pareja 6 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Vacio), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(6));
    });

    test('Cuadrado Amoroso 2 Parejas (12 pts)', () {
      var piramide = [
        [c(Tipo.Vacio, Tipo.Enamorado), vacia()],
        [vacia(), c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Enamorado)],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(12));
    });

    test('zigzag', () {
      var piramide = [
        [vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Vacio),c(Tipo.Vacio,Tipo.Enamorado),c(Tipo.Enamorado, Tipo.Vacio)],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(0));
    });

    test('Cadena Larga de Enamorados 2 Parejas 12 pts', () {
      var piramide = [
        [vacia(), vacia()],
        [vacia(), vacia(), vacia()],
        [c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Vacio), 
        c(Tipo.Enamorado, Tipo.Vacio)]
      ];
      expect(calcularPuntaje(piramide), equals(12));
    });
    test('Ejemplo pizarron', () {
      var piramide = [
        [c(Tipo.Vacio, Tipo.Enamorado), vacia()],
        [vacia(), c(Tipo.Enamorado, Tipo.Vacio), c(Tipo.Enamorado, Tipo.Enamorado)],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(12));
    });
  });

  group('Escenarios Mixtos', () {
    test('Criminal puntúa con Sacerdote', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Vacio), vacia()],
        [c(Tipo.Criminal, Tipo.Sacerdote), c(Tipo.Campesino, Tipo.Vacio), vacia()],
        [vacia(), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(3));
    });

    test('Rey, Campesino, Criminal, Sacerdote y Enamorados', () {
      var piramide = [
        [c(Tipo.Rey, Tipo.Enamorado), c(Tipo.Enamorado, Tipo.Vacio)],
        [c(Tipo.Campesino, Tipo.Vacio), vacia(), vacia()],
        [c(Tipo.Criminal, Tipo.Sacerdote), vacia(), vacia(), vacia()]
      ];
      expect(calcularPuntaje(piramide), equals(3));
    });
  });

  group('Validación de Coordenadas 1-9', () {
    Map<String, int> traducir(int pos) {
      if (pos >= 8) return {'f': 0, 'c': pos - 8};
      if (pos >= 5) return {'f': 1, 'c': pos - 5};
      return {'f': 2, 'c': pos - 1};
    }

    test('19. Mapeo Correcto', () {
      expect(traducir(1)['f'], equals(2));
      expect(traducir(5)['f'], equals(1));
      expect(traducir(9)['f'], equals(0));
    });
  });
}