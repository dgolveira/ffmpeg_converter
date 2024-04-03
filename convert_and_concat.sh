#!/bin/bash

# Defina o caminho de entrada onde estão os arquivos .webm e .mkv
input_path="in"

# Defina o caminho de saída onde os arquivos .mp4 serão salvos
output_path="out"

# Crie o diretório de saída se ele não existir
mkdir -p "$output_path"

# Encontrar todos os arquivos .webm e .mkv no diretório de entrada
# e ordená-los pelo número no nome do arquivo
files=$(find "$input_path" -maxdepth 1 \( -name '*.webm' -o -name '*.mkv' \) | sort -t '/' -k 2 -n)

# Criar um arquivo temporário para a lista de arquivos mp4 para concatenação
echo "" > "$output_path/mylist.txt"

# Contador para nomear os fragmentos
counter=1

# Converter cada arquivo para .mp4
for file in $files; do
    output_file="$output_path/Fragmento$counter.mp4"
    echo "Convertendo $file para $output_file..."
    ffmpeg -y -i "$file" -c:v copy -c:a aac -strict -2 "$output_file"
    echo "file 'Fragmento$counter.mp4'" >> "$output_path/mylist.txt"
    ((counter++))
done

# Concatenar todos os arquivos .mp4 em um único arquivo final
echo "Concatenando os arquivos em finalvideo.mp4..."
ffmpeg -f concat -i "$output_path/mylist.txt" -c copy -strict -2 "$output_path/finalvideo.mp4"

# Remover o arquivo de lista temporário
rm "$output_path/mylist.txt"

echo "Conclusão: Todos os arquivos foram convertidos e concatenados em finalvideo.mp4."
