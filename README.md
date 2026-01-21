# 📊 contador de lineas de codigo

Este script de Bash permite analizar proyectos de software y contar las líneas de código de forma detallada. Clasifica los resultados por lenguaje de programación, separando líneas de código puro, comentarios y líneas en blanco.

## 🚀 Características

* **Multilenguaje:** Reconoce más de 40 extensiones (Java, TypeScript, Python, C#, React, YAML, SQL, etc.).
* **Análisis Inteligente:** Diferencia entre líneas de código, comentarios y espacios en blanco.
* **Optimizado para Windows:** Incluye limpieza de caracteres de retorno de carro (`\r`) para funcionar sin errores en **Git Bash** o **WSL**.
* **Reporte Doble:** * Muestra una tabla organizada y ordenada de mayor a menor cantidad de código por consola.
    * Genera automáticamente un archivo `.csv` para análisis en Excel.
* **Filtros de Escaneo:** Ignora automáticamente carpetas como `node_modules`, `dist`, `build` y archivos ocultos.

## 📋 Requisitos

* Tener instalado **Git Bash** (si estás en Windows) o cualquier terminal basada en **Unix/Linux**.
* Permisos de ejecución en la carpeta del proyecto.

## 🛠️ Instalación y Uso

1.  **Crea el archivo:**
    Crea un archivo llamado `contar_codigo.sh` en la raíz de tu proyecto y pega el código del script.

2.  **Corrige el formato (Paso crítico en Windows):**
    Para evitar errores de sintaxis debido al formato de texto de Windows, ejecuta:
    ```bash
    sed -i 's/\r$//' contar_codigo.sh
    ```

3.  **Da permisos de ejecución:**
    ```bash
    chmod +x contar_codigo.sh
    ```

4.  **Ejecuta el script:**
    ```bash
    ./contar_codigo.sh
    ```

## 📈 Ejemplo de Salida en Consola

Al finalizar el escaneo, el script mostrará un resumen como este:

```text
Language              files      blank    comment       code
----------------------------------------------------------------------------
TypeScript              666       7692       7475      59552
JSON                     34         34          1      27680
SASS/SCSS               180       2305        378      25412
...
----------------------------------------------------------------------------
SUM:                   1354      14886      15435     158221
