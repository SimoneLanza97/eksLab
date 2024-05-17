import os
import base64
import zlib
import requests
import sys

# Definisci le variabili fisse
PLANTUML_DIRECTORY = "./schemas"
OUTPUT_DIRECTORY = "./images"
KROKI_URL = "http://localhost:8002/plantuml/svg"

# Verifica se le directory esistono
if not os.path.isdir(PLANTUML_DIRECTORY):
    print(f'Error: {PLANTUML_DIRECTORY} is not a valid directory', file=sys.stderr)
    sys.exit(1)

if not os.path.isdir(OUTPUT_DIRECTORY):
    os.makedirs(OUTPUT_DIRECTORY)

# Processo tutti i file nella directory di input
for filename in os.listdir(PLANTUML_DIRECTORY):
    filepath = os.path.join(PLANTUML_DIRECTORY, filename)

    # Assicurati che sia un file regolare e non una directory
    if os.path.isfile(filepath) and filename.endswith('.plantuml'):
        try:
            # Leggi il contenuto del file
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()

            # Comprimi e codifica in Base64
            compressed = zlib.compress(content.encode('utf-8'), 9)
            encoded = base64.urlsafe_b64encode(compressed).decode('utf-8')

            # Invia la richiesta GET al container Kroki
            response = requests.get(f"{KROKI_URL}/{encoded}")
            response.raise_for_status()  # Solleva un'eccezione se la richiesta fallisce

            # Salva il risultato nella directory di output
            output_filename = filename.replace('.plantuml', '.svg')
            output_filepath = os.path.join(OUTPUT_DIRECTORY, output_filename)

            with open(output_filepath, 'w', encoding='utf-8') as svg_file:
                svg_file.write(response.text)

            print(f'Converted {filename} to SVG and saved as {output_filepath}')

        except Exception as e:
            print(f'Error processing file {filename}: {e}', file=sys.stderr)
