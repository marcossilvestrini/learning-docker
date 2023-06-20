<#
.Synopsis
   Up lab for learning
.DESCRIPTION
   Set Vagrantfile for docker server
   Set folder of virtualbox VM's
   Create a semafore for vagrant up
   Copy public key for vagrant shared folder
   This script is used for create a new lab with vagrant.
   Create all VM's in Vagrantfile  
   Copy all private key of VM's for F:\Projetos\vagrant_pk folder   
.EXAMPLE
   & vagrant_up_windows.ps1
#>

# Execute script as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
   $arguments = "& '" + $myinvocation.mycommand.definition + "'"
   Start-Process -Wait powershell -Verb runAs -WindowStyle Minimized -ArgumentList $arguments
   Break
}

# Clear screen
Clear-Host

#Stop vagrant process
Get-Process -Name *vagrant* | Stop-Process -Force
Get-Process -Name *ruby* | Stop-Process -Force

# Semafore for vagrant process
$scriptPath = $PSScriptRoot
$semafore = "$scriptPath\vagrant-up.silvestrini"
New-Item -ItemType File -Path $semafore -Force >$null

# SSH
$ssh_path = "$( (($scriptPath | Split-Path -Parent)| Split-Path -Parent) | Split-Path -Parent)\security"
Copy-Item -Force "$env:USERPROFILE\.ssh\id_ecdsa.pub" -Destination $ssh_path

# Define environment for labs(notebook, desktop)
switch ($(hostname)) {
   "silvestrini" {
      # Variables
      $virtualboxFolder = "E:\Apps\VirtualBox"
      $virtualboxVMFolder = "E:\Servers\VirtualBox"       
      $vagrant = "E:\Apps\Vagrant\bin\vagrant.exe"
      $vagrantHome = "E:\Apps\Vagrant\vagrant.d"  
      $baseProject = "F:\Projetos\learning-docker"          
      $baseVagrantfile = "$baseProject\vagrant\linux"                  
      $vagrantPK = "F:\Projetos\vagrant-pk"      
   }
   "silvestrini2" {      
      # Variables
      $virtualboxFolder = "C:\Program Files\Oracle\VirtualBox"
      $virtualboxVMFolder = "D:\Cloud\VirtualBox"          
      $vagrant = "D:\Cloud\Vagrant\bin\vagrant.exe"
      $vagrantHome = "D:\Cloud\Vagrant\.vagrant.d"             
      $baseProject = "F:\Projetos\learning-docker"                
      $baseVagrantfile = "$baseProject\vagrant\linux"         
      $vagrantPK = "F:\Projetos\vagrant-pk"      
      
   }
   Default { Write-Host "This hostname is not available for execution this script!!!"; exit 1 }
}

# VirtualBox home directory.
Start-Process -Wait -NoNewWindow -FilePath "$virtualboxFolder\VBoxManage.exe" `
   -ArgumentList  @("setproperty", "machinefolder", "$virtualboxVMFolder")

# Vagrant home directory for downloadad boxes.
setx VAGRANT_HOME "$vagrantHome" >$null

# Up docker stack
$docker = "$baseVagrantfile"
Set-Location $docker
vagrant up
#Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb runAs
Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
Copy-Item .\.vagrant\machines\debian-server02\virtualbox\private_key $vagrantPK\debian-server02
Copy-Item .\.vagrant\machines\debian-server03\virtualbox\private_key $vagrantPK\debian-server03
Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# Fix powershell error
$Env:VAGRANT_PREFER_SYSTEM_BIN += 0

#Remove Semafore
Remove-Item -Force $semafore