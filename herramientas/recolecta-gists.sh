#!/usr/bin/env bash
###############################################################
# recolecta-gists.sh — Asistente de calificación (uso docente)
#
# Clona los Gists reportados por los alumnos (iDoceo Connect /
# Google Classroom), corre `make test` en cada uno EN TU MÁQUINA
# y produce un resumen para calificar con la rúbrica de GRADING.md.
#
# NO es CI: se corre después de la fecha de entrega, como apoyo
# de revisión. El alumno ya vivió sus propios errores en su entorno.
#
# Uso:
#   ./recolecta-gists.sh lista.csv [carpeta-destino]
#
# lista.csv (una línea por alumno, sin encabezado):
#   numero_control,Nombre Apellido,https://gist.github.com/usuario/abc123
#   22211540,Luis Pérez,            ← sin URL = no reportó
#   # las líneas que inician con # se ignoran
#
# Salida:
#   carpeta-destino/<control>/        ← clon del Gist de cada alumno
#   carpeta-destino/_logs/<control>.log  ← salida completa de make test
#   carpeta-destino/resumen.csv       ← para importar a iDoceo
#
# Requiere: git, make (y el toolchain ARM64/QEMU si calificas en x86).
###############################################################
set -u

CSV="${1:-}"
DEST="${2:-revision-$(date +%Y%m%d)}"

if [ -z "$CSV" ] || [ ! -f "$CSV" ]; then
  echo "Uso: $0 lista.csv [carpeta-destino]" >&2
  exit 1
fi

mkdir -p "$DEST/_logs"
RESUMEN="$DEST/resumen.csv"
echo "control,nombre,resultado,anexo,asciinema,observaciones" > "$RESUMEN"

# timeout si está disponible (gtimeout en macOS con coreutils)
TO="$(command -v gtimeout || command -v timeout || true)"
[ -n "$TO" ] && TO="$TO 120"

total=0; ok=0; fallo=0; sinurl=0

printf '%-10s %-22s %-14s %-8s %-10s %s\n' CONTROL NOMBRE RESULTADO ANEXO ASCIINEMA OBS
printf '%s\n' '--------------------------------------------------------------------------------'

while IFS= read -r linea || [ -n "$linea" ]; do
  linea="${linea%$'\r'}"                       # tolera CSV de Windows/Excel
  case "$linea" in ''|'#'*) continue ;; esac

  IFS=, read -r control nombre url <<EOF
$linea
EOF
  control="$(echo "$control" | tr -d ' "')"
  nombre="$(echo "$nombre" | sed 's/^ *//; s/ *$//; s/"//g')"
  url="$(echo "$url" | tr -d ' "')"
  [ -z "$control" ] && continue
  total=$((total+1))

  if [ -z "$url" ]; then
    sinurl=$((sinurl+1))
    printf '%-10s %-22s %-14s %-8s %-10s %s\n' "$control" "$nombre" '∅ no reportó' '-' '-' ''
    echo "$control,$nombre,no reporto URL,,," >> "$RESUMEN"
    continue
  fi

  # De la URL del Gist se extrae el hash: git clone acepta gist.github.com/<hash>.git
  clon_url="$url"
  case "$url" in
    *gist.github.com*)
      hash="${url%/}"; hash="${hash##*/}"; hash="${hash%.git}"
      clon_url="https://gist.github.com/${hash}.git"
      ;;
  esac

  dir="$DEST/$control"
  log="$DEST/_logs/$control.log"
  if [ -d "$dir/.git" ]; then
    git -C "$dir" pull --quiet > "$log" 2>&1   # re-corrida: actualiza el mismo clon
  else
    git clone --quiet "$clon_url" "$dir" > "$log" 2>&1
  fi
  if [ ! -d "$dir" ]; then
    fallo=$((fallo+1))
    printf '%-10s %-22s %-14s %-8s %-10s %s\n' "$control" "$nombre" '❌ clone' '-' '-' "URL inválida?"
    echo "$control,$nombre,error al clonar,,,revisar URL" >> "$RESUMEN"
    continue
  fi

  # make test en el entorno del docente (nunca del alumno)
  resultado='— sin make'
  res_csv='sin Makefile'
  if [ -f "$dir/Makefile" ]; then
    if ( cd "$dir" && $TO make test ) >> "$log" 2>&1; then
      if grep -q 'SKIP' "$log"; then
        resultado='⚠️ SKIP'; res_csv='SKIP (revisar evidencia)'
      else
        resultado='✅ OK'; res_csv='make test OK'; ok=$((ok+1))
      fi
    else
      resultado='❌ FAIL'; res_csv='make test FALLA'; fallo=$((fallo+1))
    fi
  fi

  # Checks rápidos de la rúbrica (detalle en GRADING.md)
  anexo='falta'
  [ -s "$dir/ANEXO.md" ] && anexo='sí'
  asciinema='falta'
  grep -qi 'asciinema' "$dir"/*.md 2>/dev/null && asciinema='sí'
  obs=''
  grep -q '<Nombre Apellido>' "$dir"/*.s "$dir"/src/*.s 2>/dev/null && obs='encabezado sin llenar'

  printf '%-10s %-22s %-14s %-8s %-10s %s\n' "$control" "$nombre" "$resultado" "$anexo" "$asciinema" "$obs"
  echo "$control,$nombre,$res_csv,$anexo,$asciinema,$obs" >> "$RESUMEN"
done < "$CSV"

printf '%s\n' '--------------------------------------------------------------------------------'
echo "Total: $total · make test OK: $ok · con problema: $fallo · sin reportar: $sinurl"
echo "Clones en: $DEST/ · Logs: $DEST/_logs/ · Resumen CSV: $RESUMEN"
