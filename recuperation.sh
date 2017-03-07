#!/bin/bash

# Sorry for French comments, but code is so simple that Google Translate is your friend (and should be mine).

# Auteur         : François de Mareschal <francois.demareschal@gmail.com>
# Historique     : @17/04/2015 création
# Fonctionnement : liste les fichiers contenus dans les sous-répertoires, en extrait les 
#                  vidéos et les photos, et le place dans un répertoire spécifique. Pour 
#		   changer les types de fichiers extraits, modifiez le tableau 
#		   'listeExtensions'
# @todo          : - permettre de spécifier quel types de fichier extraire en argument
#		   - permettre de spécifier la profondeur de répertoires à explorer
#		   - créer un sous-répertoire de sauvegarde par type de fichier

# Liste des extensions à récuperer
listeExtensions=("jpeg" "jpg" "mov" "mp3" "psd" "png")

# Liste des répertoires dans lesquels chercher
listeRepertoires="$(find * -type d -prune)"

repertoireParent="$(pwd)"					# Répertoire actuel (dans lequel s'exécute le script)
repertoireSpecial="$(echo "${repertoireParent}/sauvegarde")"	# Répertoire de stockage

mkdir -p $repertoireSpecial	# Les fichier intéressants seront déplacés ici

# Parcours de chaque sous-répertoire
for repertoire in ${listeRepertoires}; do

	echo ${repertoire}	# Affichage du répertoire
	cd   ${repertoire}	# Descente dans le répertoire

	# [WORKAROUND] Le répertoire de sauvegarde ne doit pas être visité ! Solution dégueu pour l'instant...
	if [ "$repertoire" != "sauvegarde" ]; then
		# Parcours de tous les fichiers du répertoire
		for fichier in *; do
			echo -e "\t" ${fichier}	# Affichage du fichier

			# Parcours des extensions pour tester leur correspondance
			for extension in ${listeExtensions[*]}; do
				if [ -e $fichier ] && [ -f $fichier ]; then
					extensionFichierActuel=$(echo $fichier | cut -d . -f 2)
					if [ "$extension" == "$extensionFichierActuel" ]; then
						echo -e "\t\tCopie du fichier $fichier vers $repertoireSpecial..."
						cp -f $fichier $repertoireSpecial &> /dev/null
						echo -e "\t\tCopie terminée."
					fi
				fi
			done
		done
	else
		echo -e "\t\tRépertoire de sauvegarde, passage au répertoire suivant..."
	fi

	# Remontée dans le répertoire parent
	cd ..
done

