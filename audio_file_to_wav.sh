#!/bin/bash
# Usage: ./batch_convert_audio_to_wav.sh /path/to/audio_folder /path/to/output_folder

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_folder> <output_folder>"
  exit 1
fi

input_folder="$1"
output_folder="$2"

if [ ! -d "$input_folder" ]; then
  echo "Error: Input folder '$input_folder' does not exist."
  exit 1
fi

mkdir -p "$output_folder"

shopt -s nullglob
audio_files=("$input_folder"/*.{mp3,aac,m4a})

if [ ${#audio_files[@]} -eq 0 ]; then
  echo "No supported audio files found in '$input_folder'."
  exit 0
fi

for file in "${audio_files[@]}"; do
  filename=$(basename -- "$file")
  basename_no_ext="${filename%.*}"
  output_file="$output_folder/$basename_no_ext.wav"

  echo "Converting '$file' to '$output_file'..."
  ffmpeg -hide_banner -loglevel error -i "$file" -ar 16000 -c:a pcm_s16le "$output_file"
  if [ $? -ne 0 ]; then
    echo "Failed to convert '$file'."
  else
    echo "Successfully converted '$file'."
  fi
done

echo "Conversion completed."

