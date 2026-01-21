#!/bin/bash

# =================================================================
# Contador de líneas de código - Versión Final (SUM al final)
# =================================================================

OUTPUT_CSV="reporte_lineas_codigo.csv"

echo "Analizando el proyecto (incluyendo Web, Progra y Configuración)..."
echo "Generando: $OUTPUT_CSV"
echo "------------------------------------------------------------"

# Base de datos expandida de lenguajes
declare -A LANG_MAP
LANG_MAP=( 
    ["html"]="HTML" ["css"]="CSS" ["js"]="JavaScript" ["ts"]="TypeScript" 
    ["jsx"]="React JSX" ["tsx"]="React TSX" ["scss"]="SASS/SCSS" ["sass"]="SASS"
    ["less"]="Less" ["vue"]="Vue" ["php"]="PHP" ["mustache"]="Mustache"
    ["java"]="Java" ["py"]="Python" ["c"]="C" ["cpp"]="C++" ["cs"]="C#" 
    ["h"]="C/C++ Header" ["hpp"]="C++ Header" ["go"]="Go" ["rs"]="Rust" 
    ["rb"]="Ruby" ["kt"]="Kotlin" ["swift"]="Swift" ["dart"]="Dart" 
    ["scala"]="Scala" ["groovy"]="Groovy" ["lua"]="Lua" ["pl"]="Perl" ["r"]="R"
    ["yml"]="YAML" ["yaml"]="YAML" ["xml"]="XML" ["json"]="JSON" 
    ["sql"]="SQL" ["sh"]="Bourne Shell" ["md"]="Markdown" ["bat"]="DOS Batch" 
    ["properties"]="Properties" ["toml"]="TOML" ["ini"]="INI" ["env"]="Environment" 
    ["gradle"]="Gradle" ["dockerfile"]="Docker" ["tf"]="Terraform" ["proto"]="Protocol Buffers"
)

tmp_data=$(mktemp)

# Escaneo de archivos
find . -type f \
    -not -path '*/.*' \
    -not -path '*/node_modules/*' \
    -not -path '*/dist/*' \
    -not -path '*/build/*' \
    -not -name "$OUTPUT_CSV" | while read -r file; do

    ext="${file##*.}"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    lang=${LANG_MAP[$ext]}
    
    if [ -z "$lang" ]; then continue; fi

    # Limpieza de caracteres de Windows (\r) y espacios
    total_l=$(wc -l < "$file" | tr -d '[:space:]\r')
    [ -z "$total_l" ] && total_l=0

    blank_l=$(grep -c "^[[:space:]]*$" "$file" | tr -d '[:space:]\r')
    comment_l=$(grep -c -E "^[[:space:]]*(\/\/|#|\/\*|\*|--|rem|::)" "$file" | tr -d '[:space:]\r')
    
    code_l=$((total_l - blank_l - comment_l))
    [ $code_l -lt 0 ] && code_l=0

    echo "$lang|$blank_l|$comment_l|$code_l" >> "$tmp_data"
done

# --- PROCESAMIENTO DE SALIDA ---

# Cabecera del CSV
echo "Language,Files,Blank,Comment,Code" > "$OUTPUT_CSV"

# Cabecera de Consola
printf "%-20s %10s %10s %10s %10s\n" "Language" "files" "blank" "comment" "code"
echo "----------------------------------------------------------------------------"

if [ -s "$tmp_data" ]; then
    # 1. Generamos las filas de lenguajes, las ordenamos y las mostramos
    # También guardamos los datos en el CSV
    awk -F"|" '{
        files[$1]+=1; blank[$1]+=$2; comm[$1]+=$3; code[$1]+=$4;
        t_files+=1; t_blank+=$2; t_comm+=$3; t_code+=$4;
    } 
    END {
        for (i in files) {
            printf "%-20s %10d %10d %10d %10d\n", i, files[i], blank[i], comm[i], code[i]
            # Guardar en CSV
            print i "," files[i] "," blank[i] "," comm[i] "," code[i] >> "'"$OUTPUT_CSV"'"
        }
        # Guardamos los totales en un archivo temporal para usarlos después del sort
        print t_files "|" t_blank "|" t_comm "|" t_code > "/tmp/totales_final"
    }' "$tmp_data" | sort -rn -k5

    # 2. Leemos los totales finales
    IFS='|' read -r tf tb tc tcode < /tmp/totales_final

    # 3. Imprimimos el cierre de la tabla con el SUM al final
    echo "----------------------------------------------------------------------------"
    printf "%-20s %10d %10d %10d %10d\n" "SUM:" "$tf" "$tb" "$tc" "$tcode"
    
    # Agregar el total al CSV
    echo "TOTAL,$tf,$tb,$tc,$tcode" >> "$OUTPUT_CSV"
else
    echo "No se encontraron archivos compatibles."
fi

# Limpieza
rm "$tmp_data"
[ -f /tmp/totales_final ] && rm /tmp/totales_final

echo ""
echo "✅ ¡Listo! Reporte completo generado en pantalla y en $OUTPUT_CSV"