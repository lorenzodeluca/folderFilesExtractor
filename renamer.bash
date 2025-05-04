#!/bin/bash

# Controlla se è stato fornito un parametro per la directory
if [ -z "$1" ]; then
    echo "Errore: devi fornire la directory come parametro."
    echo "Uso: $0 /percorso/della/directory"
    exit 1
fi

# Imposta la directory dalla quale rinominare i file
directory="$1"

# Controlla se la directory esiste
if [ ! -d "$directory" ]; then
    echo "Errore: la directory '$directory' non esiste."
    exit 1
fi

# Inizializza il contatore
counter=1

# Cicla su ogni file nella cartella specificata
for file in "$directory"/*; do
    # Ignora le cartelle
    if [ -f "$file" ]; then
        # Estrai la data di ultima modifica (anno e mese)
        anno=$(date -r "$file" +"%Y")
        mese=$(date -r "$file" +"%m")

        # Estrai l'estensione del file
        estensione="${file##*.}"

        # Crea il nuovo nome del file con il contatore
        nuovo_nome="${anno} - ${mese} - ${counter}.${estensione}"

        # Rinomina il file
        mv "$file" "$directory/$nuovo_nome"

        # Incrementa il contatore
        ((counter++))
    fi
done

echo "Rinomina completata!"
