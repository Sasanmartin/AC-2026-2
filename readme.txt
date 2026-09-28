Requerimientos:

	1.- Windows >= 7 64-bit o Ubuntu =< 22.4 64-bit

	2.- 25 GB en el destino de la instalación


Procedimiento Windows 64-bit:

	1.1- Ejecutar como administrador: install_webpack_windows.bat

		1.2.- Aceptar la instalación del driver

	2.- Abrir Vivado desde el menú de inicio

		2.1- Abrir Manage Xilinx Licences desde: Help --> Manage License...
		
			2.1.1 - Agregar la licencia (Xilinx.lic) desde: Load licence --> Copy licence


Procedimiento Ubuntu =< 22.4 64-bit:

	1.- Ejecutar el comando : sudo ./install_webpack_linux.sh

	2.- Instalar drivers con el comando: sudo ./install_drivers
		desde /tools/Xilinx/Vivado/2019.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/

	3.- Configurar el entorno con el comando: source /tools/Xilinx/Vivado/2019.2/settings64.sh

	4.- En Ubuntu >= 20.4 usar el comando: sudo apt install libncurses5

	5.- Abrir Vivado con el comando: vivado &

		5.1- Abrir Manage Xilinx Licences desde: Help --> Manage License...
		
			5.1.1 - Agregar la licencia (Xilinx.lic) desde: Load licence --> Copy licence


		
Cambiar el destino de la instalación por defecto:

	1.- Abrir install_config.txt

		1.1- Des comentar la línea 5 o 6 y cambiar el path de destino



