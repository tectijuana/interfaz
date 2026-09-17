# Exposición Demo — Lectura Serial de micro:bit

## Lenguajes de programación compatibles

1. **Python** — `pyserial` (`serial.Serial('COMx', 115200)`). El más usado para esto; fácil de combinar con `pandas`, `matplotlib`, `numpy` para graficar/procesar en tiempo real.
2. **JavaScript / Node.js** — `serialport` (npm). Útil si quieres mandar los datos a una app web o dashboard (Electron, Express, sockets).
3. **Processing (Java-based)** — librería `Serial` incluida. Muy común en proyectos educativos/maker para graficar datos en vivo.
4. **C / C++** — acceso directo a puerto serial (`termios` en Linux/Mac, `Win32 API` en Windows) o librerías como `libserialport`. Más control, útil si necesitas rendimiento o embeberlo en otro sistema.
5. **Kotlin** — puede usar `jSerialComm` (misma librería que Java, ya que Kotlin corre sobre la JVM). Buena opción si prefieres sintaxis moderna con interoperabilidad Java, o para apps Android que reciban el stream por USB-OTG.
6. **C# (.NET)** — `System.IO.Ports.SerialPort`. Útil para apps de escritorio Windows.
7. **Java** — `jSerialComm` o RXTX. Alternativa multiplataforma a C#.
8. **Rust** — crate `serialport-rs`. Si buscas rendimiento y seguridad de memoria.
9. **Go** — `go.bug.st/serial` o `tarm/serial`. Simple para servicios/backends que consuman el stream.
10. **PHP** — extensión `dio` (direct I/O) o librerías como `php-serial`. Poco común pero viable si ya tienes un backend PHP y quieres integrar el stream ahí.

## Equipos (26b-Lenguajes de Interfaz 5pm)

| Lenguaje | Nombre completo |
|---|---|
| Python | DIEGO VALDEZ GARCIA |
| Python | EARVIN ALEJANDRO SAINZ MONTOYA |
| Python | ANGEL FERNANDO LARES MENA |
| Python | MAILEN GISELL ROSALES X |
| JavaScript / Node.js | ISAAC HILARIO PEÑA GONZALEZ |
| JavaScript / Node.js | RICARDO DAVID VALDEZ AMPARO |
| JavaScript / Node.js | ADAN YAÑEZ AGUILAR |
| JavaScript / Node.js | ANGEL IVAN NAVARRO JIMENEZ |
| Processing | ALEJANDRO GUARNEROS VILLANUEVA |
| Processing | RICARDO ARAOZ SIERRA |
| Processing | HECTOR ARTURO MENDOZA VELAZQUEZ |
| Processing | JAIME NAEL AGUIRRE LOPEZ |
| C / C++ | BRANDON EMILIO RAYGOZA TOLEDO |
| C / C++ | UBER MAURICIO PEREZ RAMIREZ |
| C / C++ | JOSE MANUEL RUIZ SANCHEZ |
| Kotlin | JOSE GUSTAVO GUERRA HABANA |
| Kotlin | ALVARO GABINO CASAS RAMIREZ |
| Kotlin | MARIO ALEJANDRO JOVEL CUEN |
| Kotlin | ERNESTO ORTEGA UNZUETA |
| C# (.NET) | FRANCISCO YAMIL ROMERO GARCIA |
| C# (.NET) | JOLIET IVET FLORES REYES |
| C# (.NET) | CARLOS ELIAB RODRIGUEZ PERAZA |
| C# (.NET) | LEONARDO MUÑOZ GUZMAN |
| Java | CESAR RICARDO VAZQUEZ SANCHEZ |
| Java | LEONARDO GALLEGOS HERNANDEZ |
| Java | TANIA LIZETH TAVERA ALANIS |
| Java | ANGEL GERARDO MURUA RAMIREZ |
| Rust | LUIS FELIPE GARCIA PASCENCIA |
| Rust | JASON JARIB ANTONIO ALBAÑIL |
| Rust | JOSE ALBERTO JARDIN GRACIA |
| Rust | ANGEL EDUARDO CORTES HUERTA |
| Go | KEVIN JAHIR PLATA CRUZ |
| Go | TAI PING ALEJANDRA RUAN LOPEZ |
| Go | MARIO ALBERTO URQUIZA HERRERA |
| Go | JOSHUA JONATHAN LARA FERNANDEZ DE LARA |
| PHP | JOEL CARRERA AGUIRRE |
| PHP | ADRIAN CAMACHO TORRES |
| PHP | ISURY MICHELLE CAB PIÑON |
| PHP | CESAR ADRIAN LUIS JUAN CAMACHO |
