#!/bin/bash

# Vérifie si le nombre d'arguments est suffisant
if [ "$#" -lt 3 ]; then
	echo "Usage: $0 <dossier> <nombre_de_fichiers> <nombre_d_images>..."
	exit 1
fi

# Récupère les arguments
dossier=$1
shift
nombre_de_fichiers=$1
shift
nombre_d_images=("$@")

# Vérifie si le dossier existe
if [ ! -d "$dossier" ]; then
	echo "Le dossier $dossier n'existe pas."
	exit 1
fi

# Récupère toutes les images du dossier
images=("$dossier"/*.{jpg,jpeg,png,gif})
nombre_total_images=${#images[@]}

# Vérifie si le nombre d'images est suffisant
for nombre in "${nombre_d_images[@]}"; do
	if [ "$nombre" -gt "$nombre_total_images" ]; then
		echo "Il n'y a pas assez d'images dans le dossier $dossier."
		exit 1
	fi
done

# Crée les fichiers HTML
for ((i=0; i<nombre_de_fichiers; i++)); do
	fichier="index$((i+1)).html"
	nombre_images=${nombre_d_images[$i]}
	
	echo "<html>" > "$fichier"
	echo "<body>" >> "$fichier"
	
	for ((j=0; j<nombre_images; j++)); do
		image=${images[RANDOM % nombre_total_images]}
		if [ -f "$image" ]; then
			echo "<img src=\"$image\" alt=\"Image\">" >> "$fichier"
		else
			j=$((j-1)) # Retry if the selected image is not a file
		fi
	done
	
	echo "</body>" >> "$fichier"
	echo "</html>" >> "$fichier"
done

echo "Les fichiers HTML ont été créés avec succès."

python3 -m http.server 8000