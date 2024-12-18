#!/bin/bash
# Descripción: Instala automáticamente toda la personalización instalada
# Última actualización: 18 Nov 2024
#
# PREREQUISITOS: La responsabilidad de comprobar si el nombre del paquete es correcto recae en el usuario
#
# Lista:
#	Snap: brave, Clion, Spotify, gedit, Steam, Mindustry
#	Flatpak y la tienda de software: ASCII Draw, Blanket, Calligraphy, Colisión, Gestor de extensiones, Obsidian, Pinta, Retoques de GNOME, Gestor tipográfico, emblema, letterpress, 
#	Tweaks
#	Extensiones: ArcMenu, Blur my Shell, Clipboard Indicator, Dash to Panel, User Themes, Vitals, AppIndicator and KStatusNotifierItem Support
#	Orchis theme (dracula version)
#	Oh my posh

listaSnap=(brave "--classic clion" spotify gedit steam mindustry)
listaFlatpak=(org.gnome.design.Emblem com.rafaelmardojai.Blanket io.github.nokse22.asciidraw dev.geopjr.Calligraphy io.gitlab.gregorni.Letterpress dev.geopjr.Collision com.mattjakeman.ExtensionManager md.obsidian.Obsidian com.github.PintaProject.Pinta)

read -p "Bienvenido al instalador de recuperación Ringo ¿Desea proceder a la recuperación o quiere añadir algún programa? (recu/prog): " respuesta

if [[ ${respuesta} == "prog" ]]; then
	read -p "¿El programa es un paquete snap o flatpak? (snap/flatpak): " tipoPaquete
	read -p "Introduzca el paquete: " paquete
	if [[ ${tipoPaquete} == "snap" ]]; then
		listaSnap=(paquete ${listaSnap[@]})
	fi
	if [[ ${tipoPaquete} == "flatpak" ]]; then
		listaFlatpak=(paquete ${listaFlatpak[@]})
	fi
fi
	
if [[ ${respuesta} == "recu" ]]; then
##### Install aplicaciones de snap
	for snapApp in "${listaSnap[@]}"; do
		echo "################### DESCARGANDO ${snapApp} ###################"
		snap install ${snapApp} 
	done

##### Instalación flatpak y flathub	
	sudo apt install gnome-software-plugin-flatpak -y

	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	for flatpakApp in "${listaFlatpak[@]}"; do
		echo "################### DESCARGANDO ${flatpakApp} ###################"
		flatpak install flathub ${flatpakApp} -y
	done

##### Instalar tweaks
	sudo apt install gnome-tweaks

##### Instalar extensiones del gestor de gnome
	mkdir -p /home/cesar/.local/share/gnome-shell
	extensiones=$(find -name Extensions.zip)

	if [[ $extensiones == "" ]]; then
		echo "Error no se ha encontrado el .zip Extensiones"
		exit
	fi

 	mkdir -p ~/.local/share/gnome-shell
	unzip -o Extensions.zip -d ~/.local/share/gnome-shell

##### Instalar Orchis theme
	if [ $(which git) = "" ]; then
		sudo apt install git
	fi
	
	git clone https://github.com/vinceliuice/Orchis-theme.git
	
	

	Orchis-theme/install.sh -l -t grey -c dark -s standard --tweaks macos submenu dracula dock --shell 46
	exit
fi

echo -e "Error al instroducir el campo \U1F62B"
