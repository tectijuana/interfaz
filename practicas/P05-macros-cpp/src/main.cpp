// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : main.cpp (P05)                                 ║
// ║  Descripción: C++ que llama funciones escritas en          ║
// ║  ensamblador ARM64 y generadas por una macro.              ║
// ╚══════════════════════════════════════════════════════════╝

#include <iostream>

// Solo la FIRMA: los cuerpos viven en macros.o.
// extern "C" evita el name mangling de C++ para que el linker
// encuentre los símbolos tal como los generó la macro.
extern "C" {
    long suma(long a, long b);
    long resta(long a, long b);
    long mult(long a, long b);
}

int main() {
    long a = 7, b = 5;
    std::cout << "suma("  << a << "," << b << ") = " << suma(a, b)  << "\n";
    std::cout << "resta(" << a << "," << b << ") = " << resta(a, b) << "\n";
    std::cout << "mult("  << a << "," << b << ") = " << mult(a, b)  << "\n";
    return 0;
}
