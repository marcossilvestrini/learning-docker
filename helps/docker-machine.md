# Docker Machine (deprecated)

## Bug network solved

```sh

1- procure a maquina usando docker-machine ls
1.1- remova ela docker-machine rm -y <machineName>

2- busque os adaptadores de rede VBoxManage list hostonlyifs
2.1- remova ele VBoxManage hostonlyif remove <networkName>

3- cria uma pasta vbox no diretorio etc usando sudo mkdir

4- dentro da pasta vbox crie o arquivo networks.conf: sudo touch networks.conf

5-dentro do arquivo coloque a linha abaixo
* 0.0.0.0/0 ::/0COPIAR CÓDIGO

6- crie a maquina virtual docker-machine create -d virtualbox <machineName>

7- rode o comando eval $(docker-machine env <machineName>) para configurar o shell

```
