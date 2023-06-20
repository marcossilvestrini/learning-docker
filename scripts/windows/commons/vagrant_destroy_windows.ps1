<#
.Synopsis
   Destroy lab for learning
.DESCRIPTION
   This script is used for destroy lab with vagrant.
   Destroy and delete all VM's in Vagrantfile
   Delete all folders with VM's in Vagrantfile
.EXAMPLE
   & vagrant_destroy_windows.ps1
#>

# Execute script as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process -Wait powershell -Verb runAs -WindowStyle Hidden -ArgumentList $arguments
  Break
}

#Stop vagrant process
Get-Process -Name *vagrant* | Stop-Process -Force
Get-Process -Name *ruby* | Stop-Process -Force

#  define variables
switch ($(hostname)) {
    "silvestrini" {       
        $vagrant = "E:\Apps\Vagrant\bin\vagrant.exe"
        $baseVagrantfile="F:\Projetos\learning-docker\vagrant"
        $vagrantHome = "E:\Apps\Vagrant\vagrant.d"      
        $virtualboxFolder = "E:\Apps\VirtualBox"
        $virtualboxVMFolder = "E:\Servers\VirtualBox" 
    }
    "silvestrini2" {      
        # Variables
        $vagrant = "D:\Cloud\Vagrant\bin\vagrant.exe"  
        $baseVagrantfile="F:\Projetos\learning-docker\vagrant"        
        $vagrantHome = "D:\Cloud\Vagrant\.vagrant.d"      
        $virtualboxFolder = "C:\Program Files\Oracle\VirtualBox"
        $virtualboxVMFolder = "D:\Cloud\VirtualBox"
    }
    Default { Write-Host "This hostname is not available for execution this script!!!"; exit 1 }
}

# VirtualBox home directory.
Start-Process -Wait -NoNewWindow -FilePath "$virtualboxFolder\VBoxManage.exe" `
    -ArgumentList  @("setproperty", "machinefolder", "$virtualboxVMFolder")

# Vagrant home directory for downloadad boxes.
setx VAGRANT_HOME $vagrantHome >$null

#Vagrant Boxes
$docker="$baseVagrantfile\linux"

# VM name
$vmName= @(
    "ol9-server01",
    "debian-server01",
    "debian-server02",
    "debian-server03"
)

# Folder vagrant virtualbox machines artefacts
$vmFolders = @(    
    $vmName | ForEach-Object{
        "$virtualboxVMFolder\$($_)"
    }
)

# Folder vagrant virtualbox machines artefacts
$vmStorageFolders = @(    
    $vmName | ForEach-Object{
        "$virtualboxVMFolder\Storage\$($_)"
    }    
)

#Destroy lab stack
Set-Location $docker
Start-Process -Wait -WindowStyle Hidden  -FilePath $vagrant -ArgumentList "destroy -f"  -Verb RunAs

# Delete folder virtualbox machines artefacts
$vmFolders | ForEach-Object {
    If (Test-Path $_) {
        If ( (Get-ChildItem -Recurse $_).Count -lt 3 ) {            
            Remove-Item $_ -Recurse -Force
        }        
    }
}

# Delete folder virtualbox machines storage
$vmStorageFolders | ForEach-Object {
    If (Test-Path $_) {
        If ( (Get-ChildItem -Recurse $_).Count -lt 3 ) {            
            Remove-Item $_ -Recurse -Force
        }        
    }
}