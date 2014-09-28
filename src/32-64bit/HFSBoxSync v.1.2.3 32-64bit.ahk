;~ HFSBoxSync v1.2.3 32-64bit
;~ By LeReverandNox, Camarade35 & Inquisitom
;~ For HyperFreeSpin, love you guys ;)

#LTrim on
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%

;~ On inclue la library TF et RunAsAdmin
#Include tf.ahk
#Include RunAsAdmin.ahk

;~ On rajoute une fonction pour desactiver le close button
DisableCloseButton(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}

;~ On lance le script en tant qu'Administrateur
RunAsAdmin()

;~ On definit le config.xml dans une variable
config := "%HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing\config.xml"

;~ On extrait les fichiers necessaires au package
FileCreateDir, %A_Temp%\HFSBoxSync

FileInstall, Ressources\HFSSync.exe, %A_Temp%\HFSBoxSync\HFSSync.exe
FileInstall, Ressources\HFSBoxMusic.mp3, %A_Temp%\HFSBoxSync\HFSBoxMusic.mp3
FileInstall, Ressources\icone_hfsbox.ico, %A_Temp%\HFSBoxSync\icone_hfsbox.ico
FileInstall, Ressources\icone_hfssync.ico, %A_Temp%\HFSBoxSync\icone_hfssync.ico
;~ ---------------------------------------------------------------------------------------------------------
FileInstall, Ressources\banniere.png, %A_Temp%\HFSBoxSync\banniere.png
FileInstall, Ressources\border.png, %A_Temp%\HFSBoxSync\border.png
FileInstall, Ressources\border2.png, %A_Temp%\HFSBoxSync\border2.png
FileInstall, Ressources\border3.png, %A_Temp%\HFSBoxSync\border3.png
FileInstall, Ressources\FirstGui.png, %A_Temp%\HFSBoxSync\FirstGui.png
FileInstall, Ressources\Fond.jpg, %A_Temp%\HFSBoxSync\Fond.jpg
FileInstall, Ressources\hard_disk.png, %A_Temp%\HFSBoxSync\hard_disk.png
FileInstall, Ressources\IntroGui.png, %A_Temp%\HFSBoxSync\IntroGui.png
FileInstall, Ressources\SecondGui.png, %A_Temp%\HFSBoxSync\SecondGui.png
FileInstall, Ressources\ThirdGui.png, %A_Temp%\HFSBoxSync\ThirdGui.png
FileInstall, Ressources\bordermini.png, %A_Temp%\HFSBoxSync\bordermini.png
FileInstall, Ressources\MiniGui.png, %A_Temp%\HFSBoxSync\MiniGui.png

;~ On récupere l'ini...
UrlDownloadToFile, http://hyperfreespin.fr/HFSBox/HFSBoxSync.ini, %A_Temp%\HFSBoxSync\HFSBoxSync.ini
IniRead, Success_Download, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, Taille_Box
;~ ... et on le teste !
If (Success_Download != "ERROR")
{
}
else
{
	msgbox, Le serveur est actuellement inaccessible, veuillez vérifier votre connexion Internet
	GoSub, Suppression
}

;~ On joue la zizique
SoundPlay, %A_Temp%\HFSBoxSync\HFSBoxMusic.mp3

;~ Gui de présentation
Gui, Add, Picture, x-6 y-8 w610 h560 , %A_Temp%\HFSBoxSync\IntroGui.png
Gui, Add, Button, x184 y502 w240 h40 , Commencer !
Gui, Add, Button, x15 y505 w100 h35 , Silence 
Gui, Add, Button, x490 y505 w100 h35 , Musique !
;~ Generated using SmartGUI Creator 4.0
Gui, Show, Center h554 w595, Présentation
DisableCloseButton()
return

Etape0:
{
Gui, Destroy
;~ On verifie si on est sur un OS 64bit
VarSetCapacity(si,44)
DllCall("GetNativeSystemInfo", "uint", &si)
arc := NumGet(si,0,"ushort")
;~ Si c'est un OS 32bit, on lui propose tout de même l'installation
if (arc == 0)
{
	Gui, Add, Picture, x-6 y-8 w410 h230 , %A_Temp%\HFSBoxSync\MiniGui.png
	Gui, Add, Picture, x54 y32 w300 h90 , %A_Temp%\HFSBoxSync\bordermini.png
	Gui, Add, Button, x100 y158 w80 h35 , Non
	Gui, Add, Button, x225 y158 w80 h35 , Oui
	Gui, Add, Text, x62 y40 w290 h20 vText1, ATTENTION LA HFSBOX NE FONCTIONNE QU'EN 64BIT
	Gui, Add, Text, x120 y60 w160 h30 vText2, Nous vous proposons néanmoins
	Gui, Add, Text, x130 y70 w160 h30 vText3, la possibilité de la synchroniser
	Gui, Add, Text, x85 y100 w240 h20 vText4, ÊTES-VOUS SUR DE VOULOIR CONTINUER ?
	GuiControl +BackgroundTrans, Text1
	GuiControl +BackgroundTrans, Text2
	GuiControl +BackgroundTrans, Text3
	GuiControl +BackgroundTrans, Text4
	; Generated using SmartGUI Creator 4.0
	Gui, Show, Center h200 w400, ATTENTION
	DisableCloseButton()
	
	Return

}
;~ Si c'est un OS 64bit, on extrait le syncthing64 et on continue
else
{
	FileInstall, Ressources\syncthing64.exe, %A_Temp%\HFSBoxSync\syncthing.exe
}
GoTo, Etape1
}

Etape1:
{
	;~ On lit la taille de la Box dans l'ini et on l'arrondi
	IniRead, Taille_Box, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, Taille_Box
	Taille_BoxGO := Taille_Box / 1024
	Taille_BoxGOR := Round(Taille_BoxGO)
	
	
;~ Si une installation existe deja, on propose l'ecrasement
IfExist, %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing\config.xml
{
	Gui, Add, Picture, x-6 y-8 w410 h230 , %A_Temp%\HFSBoxSync\MiniGui.png
	Gui, Add, Picture, x54 y32 w300 h90 , %A_Temp%\HFSBoxSync\bordermini.png
	Gui, Add, Text, x110 y55 w256 h30 vText1, Une précédente installation est détectée
	Gui, Add, Text, x157 y80 w256 h20 vText2, Que voulez-faire ?
	Gui, Add, Button, x162 y158 w80 h35 , Désinstaller
	Gui, Add, Button, x290 y158 w80 h35 , Réinstaller
	Gui, Add, Button, x30 y158 w80 h35 ,  Quitter
	GuiControl +BackgroundTrans, Text1
	GuiControl +BackgroundTrans, Text2    
	; Generated using SmartGUI Creator 4.0
	Gui, Show, Center h200 w400, ATTENTION
	DisableCloseButton()
	
	Return
}
 
;~ Si pas d'installation, on installe ^^
Else ;modification du lanceur avec intégration de la bannière et AutoSize de la fenêtre.
{
CustomColor = ffffff ; Can be any RGB color (it will be made transparent below).
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor% 0
Gui, Add, Picture, x-6 y-8 w610 h560 , %A_Temp%\HFSBoxSync\FirstGui.png
Gui, Add, Picture, x224 y152 w340 h300 , %A_Temp%\HFSBoxSync\border.png
Gui, Add, Text, x236 y190 w220 h20 vText1, Bienvenue dans l'installation de la HFSBox
Gui, Add, Text, x236 y205 w320 h20 vText2, Assurez-vous d'être sur l'ordinateur concerné avant de commencer.
Gui, Add, Text, x236 y240 w320 h20 vText3, Pour installer et profiter au mieux de la HFSBox il vous faudra :
Gui, Add, Text, x244 y270 w290 h20 vText4, - OS : Windows 7 SP1 / 8 / 8.1 64bit
Gui, Add, Text, x244 y285 w290 h20 vText5, - DD : En ce moment : un peu plus de %Taille_BoxGOR%Go
Gui, Add, Text, x244 y300 w240 h20 vText6, - Une connexion internet, un navigateur web et un 
Gui, Add, Text, x250 y315 w240 h20 vText7, pare feu autorisant le transfert.
GuiControl +BackgroundTrans, Text1
GuiControl +BackgroundTrans, Text2
GuiControl +BackgroundTrans, Text3
GuiControl +BackgroundTrans, Text4
GuiControl +BackgroundTrans, Text5
GuiControl +BackgroundTrans, Text6
GuiControl +BackgroundTrans, Text7
Gui, Add, Button, x460 y505 w100 h35 , Commencer
Gui, Add, Button, x350 y505 w100 h35 , Quitter
; Generated using SmartGUI Creator 4.0
Gui, Show, center h552 w602, Bienvenue dans l’installation...
DisableCloseButton()
return
}
}

Etape2:
{
;~ Stocke la liste des drive du poste
DriveGet, list,list
liste_drive = %list%

;~ Décompose la liste des drive dans la DropDownList:
MesDisques:=""
StringSplit, MyDrive, liste_drive ,,

Loop, %MyDrive0%
{
Mylist := MyDrive%a_index%
MyFolder = %Mylist%:\

DriveGet, cap, capacity, %MyFolder%
DrivespaceFree, free, %MyFolder%
DriveGet, type, type, %MyFolder%
DriveGet, status, status, %MyFolder% 

if (type == "Fixed" && status == "Ready" && free > Taille_Box) ; On verifie que le lecteur est bien un HDD avec 50Go de libre
{
;ici on a le BON disque qui correspond à tous nos critères
StringLeft, OutputVar, MyFolder, 1

; On affiche la taille en Go et on arrondi
FreeSpaceGO := free / 1024
FreeSpaceGOR := Round(FreeSpaceGO)

if (MesDisques != "" )
{
MesDisques = %MesDisques%||%OutputVar%:\    %FreeSpaceGOR% Go libre
}
else
{
MesDisques = %OutputVar%:\    %FreeSpaceGOR% Go libre
}
}
}

Gui, Add, Picture, x-6 y-8 w610 h560 , %A_Temp%\HFSBoxSync\SecondGui.png
Gui, Add, Picture, x224 y152 w340 h300 , %A_Temp%\HFSBoxSync\border2.png
Gui, Add, Text, x250 y200 w190 h20 vText3, Choissisez le disque pour l'installation
GuiControl +BackgroundTrans, Text1
Gui, Add, DDL, x250 y230 w120 h100 vdrive, %MesDisques%

; On verifie qu'au moins 1 disque est detecte, sinon le boutton OK ne s'affiche pas et on invite à faire un rescan
if (MesDisques != "" )
{
Gui, Add, Button, x460 y505 w100 h35 gdrive, OK
}
else
{
msgbox, Aucun disque compatible n'a été détecté, veuillez vérifer votre configuration
}

Gui, Add, Button, x240 y505 w100 h35, Annuler
Gui, Add, Button, x350 y505 w100 h35, Rescan
; Generated using SmartGUI Creator 4.0
Gui, Show, Center h552 w602, Selection du Disque
DisableCloseButton()
return


Drive:
GuiControlGet, drive
if (drive != “”)
{
Gosub, Etape3
return
}

else
{
msgbox, 64, , Veuillez sélectionner un disque valide, merci.
return
}
}

Etape3:
{
; On detruit le GUI précédent
Gui, Destroy
; On creer un GUI avec une progress bar qu'on incremente à la fin de chaque etape
Gui, Add, Picture, x-6 y-8 h400 w600 , %A_Temp%\HFSBoxSync\Fond.jpg
Gui, Add, Text, x125 y40 w180 h20 vText1, Installation en cours...
Gui, Add, Progress, x10 y10 w320 h20 cBlue vMyProgress
GuiControl +BackgroundTrans, Text1
Gui, Show, center h60 w340, Installation en cours...
DisableCloseButton()

; On creer le repertoire pour Syncthing
FileCreateDir, %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing
GuiControl,, MyProgress, +11

; On creer un script bat qui sert a generer le node ID et a recup le StdOut
FileAppend,
(
chcp 1250
cd %temp%\HFSBoxSync
syncthing.exe -generate="%HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing" > node.txt
), %A_Temp%\HFSBoxSync\generate.bat
GuiControl,, MyProgress, +11

; On l'execute, puis le supprime
RunWait, %A_Temp%\HFSBoxSync\generate.bat, %A_Temp%\HFSBoxSync,hide,
FileDelete, %A_Temp%\HFSBoxSync\generate.bat
GuiControl,, MyProgress, +11

;On stock le chemin de node dans une variable
node = %A_Temp%\HFSBoxSync\node.txt
;On decortique le node ID et on le stock dans une variable
node_client := TF_ReadLines(node, 2, 2, RemoveTrailing = 1)
StringTrimLeft, node_client, node_client, 24
StringTrimRight, node_client, node_client, 1
FileDelete, %A_Temp%\HFSBoxSync\node.txt
GuiControl,, MyProgress, +11

; On "installe" Syncthing et HFSSync dans ProgramFiles
FileCreateDir, %A_ProgramFiles%\Syncthing
FileMove, %A_Temp%\HFSBoxSync\syncthing.exe, %A_ProgramFiles%\Syncthing, 1
FileMove, %A_Temp%\HFSBoxSync\HFSSYnc.exe, %A_ProgramFiles%\Syncthing, 1
GuiControl,, MyProgress, +11

; On installe les icones dans ProgramFiles
FileMove, %A_Temp%\HFSBoxSync\icone_hfsbox.ico, %A_ProgramFiles%\Syncthing, 1
FileMove, %A_Temp%\HFSBoxSync\icone_hfssync.ico, %A_ProgramFiles%\Syncthing, 1
GuiControl,, MyProgress, +11

; On recupère la lettre du disque
StringMid, lettre, drive, 1, 1

;~ On lit ces parametres dans l'ini
IniRead, NodeID_Server, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, NodeID_Server
IniRead, Address_Server, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, Address_Server
IniRead, Port_Server, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, Port_Server
IniRead, Name_Server, %A_Temp%\HFSBoxSync\HFSBoxSync.ini, Settings, Name_Server

; On creer le XML from scratch
FileAppend,
(
<configuration version="4">
    <repository id="HFSBox" directory="%lettre%:\HFSBox" ro="false" rescanIntervalS="60" ignorePerms="false">
        <node id="%NodeID_Server%"></node>
        <node id="%node_client%"></node>
        <versioning></versioning>
    </repository>
    <node id="%NodeID_Server%" name="%Name_Server%" compression="true">
        <address>%Address_Server%:%Port_Server%</address>
    </node>
    <gui enabled="true" tls="false">
        <address>127.0.0.1:8080</address>
    </gui>
    <options>
        <listenAddress>0.0.0.0:22000</listenAddress>
        <globalAnnounceServer>announce.syncthing.net:22026</globalAnnounceServer>
        <globalAnnounceEnabled>true</globalAnnounceEnabled>
        <localAnnounceEnabled>true</localAnnounceEnabled>
        <localAnnouncePort>21025</localAnnouncePort>
        <localAnnounceMCAddr>[ff32::5222]:21026</localAnnounceMCAddr>
        <parallelRequests>16</parallelRequests>
        <maxSendKbps>0</maxSendKbps>
        <maxRecvKbps>0</maxRecvKbps>
        <reconnectionIntervalS>60</reconnectionIntervalS>
        <startBrowser>true</startBrowser>
        <upnpEnabled>true</upnpEnabled>
        <upnpLeaseMinutes>0</upnpLeaseMinutes>
        <upnpRenewalMinutes>30</upnpRenewalMinutes>
        <urAccepted>1</urAccepted>
        <restartOnWakeup>true</restartOnWakeup>
    </options>
</configuration>
), %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing\config.xml
GuiControl,, MyProgress, +11

; On ecrit la demande
FileDelete, %A_Desktop%\Demande_HFSBox.txt
FileAppend,
(
Bonjour %A_UserName%
Pour télécharger la HFSBox et la mettre à jour merci de nous transmettre le code suivant par MP à l'utilisateur HFSBox:
%node_client%
L'équipe HyperFreeSpin
), %A_Desktop%\Demande_HFSBox.txt
GuiControl,, MyProgress, +11

; On creer les raccourcis
FileCreateShortcut, %A_ProgramFiles%\Syncthing\HFSSync.exe, %A_Desktop%\HFS Sync.lnk, , , , %A_ProgramFiles%\Syncthing\icone_hfssync.ico
FileCreateShortcut, %lettre%:\HFSBox\HyperSpin.exe, %A_Desktop%\HFSBox.lnk, , , , %A_ProgramFiles%\Syncthing\icone_hfsbox.ico
GuiControl,, MyProgress, +11

GoTo, Etape4
}

Etape4:
{
	Gui, Destroy
	
	Gui, Add, Picture, x-6 y-8 w510 h230 , %A_Temp%\HFSBoxSync\MiniGui.png
	Gui, Add, Picture, x25 y20 w450 h110 , %A_Temp%\HFSBoxSync\bordermini.png
	Gui, Add, Text, x130 y40 vText1, Félicitations, vous venez d'installer la HFSBox
	Gui, Add, Text, x68 y60 vText2, Veuillez envoyer ce code par MP à l'utilisateur du forum nommé : HFSBox
	Gui, Add, Text, x40 y95 vText3, %node_client%
	Gui, Add, Button, x260 y158 w100 h35, Copier la clé ; bouton copier la clef
	Gui, Add, Button, x380 y158 w100 h35, Terminer
	GuiControl +BackgroundTrans, Text1
	GuiControl +BackgroundTrans, Text2
	GuiControl +BackgroundTrans, Text3
	Gui, Show, Center h200 w500, Fin de l'installation

	DisableCloseButton()
    return
	
}

Etape6:
{
	Gui, Destroy
	
	;~ Stocke la liste des drive du poste
	DriveGet, list,list
	liste_drive = %list%
	
	;~ Décompose la liste des drive dans la DropDownList:
	
	MesDisques:=""
	StringSplit, MyDrive, liste_drive ,,
	Loop, %MyDrive0%
{
	Mylist := MyDrive%a_index%
	MyFolder = %Mylist%:\

	DriveGet, cap, capacity, %MyFolder%
	DrivespaceFree, free, %MyFolder%
	DriveGet, type, type, %MyFolder%
	DriveGet, status, status, %MyFolder% 

	if (type == "Fixed" && status == "Ready") ; On verifie que le lecteur est bien un HDD
{
	;ici on a le BON disque qui correspond à tous nos critères
	StringLeft, OutputVar, MyFolder, 1

; On affiche la taille en Go et on arrondi
	FreeSpaceGO := free / 1024
	FreeSpaceGOR := Round(FreeSpaceGO)

	if (MesDisques != "" )
{
	MesDisques = %MesDisques%||%OutputVar%:\    %FreeSpaceGOR% Go libre
}
else
{
	MesDisques = %OutputVar%:\    %FreeSpaceGOR% Go libre
}
}
}
	Gui, Add, Picture, x-6 y-8 w610 h560 , %A_Temp%\HFSBoxSync\ThirdGui.png
	Gui, Add, Picture, x224 y152 w340 h300 , %A_Temp%\HFSBoxSync\border3.png
	Gui, Add, Text, x250 y195 w280 h20 vText3, Selectionnez le Disque où est installée la HFSBox
	GuiControl +BackgroundTrans, Text3
	Gui, Add, DDL, x250 y235 w120 h100 vdrive, %MesDisques%
	Gui, Add, Button, x10 y505 w100 h35 gRescan, Rescan
	Gui, Show, Center h552 w602, Selection du Disque
	Gui, Add, Text, x115 y32 w250 h20 vText1, Desinstallation ?
	
	; On verifie qu'au moins 1 disque est detecte, sinon le boutton OK ne s'affiche pas et on invite à faire un rescan
	if (MesDisques != "" )
	{
	Gui, Add, Button, x305 y505 w130 h35 gTotale, Supression Totale
	Gui, Add, Button, x165 y505 w130 h35 gSync, Suppression Sync
	}
	else
	{
	msgbox, Aucun disque compatible n'a été détecté, veuillez vérifer votre configuration
	}

	Gui, Add, Button, x490 y505 w100 h35, Annuler
	GuiControl +BackgroundTrans, Text1
	; Generated using SmartGUI Creator 4.0
	Gui, Show, center h552 w602, Désinstallation
	DisableCloseButton()
	return
	
	Totale:
	GuiControlGet, drive
	
	;~ On récuere la lettre du disque
	StringMid, lettre, drive, 1, 1
	
	;~ On vérifie que le dossier HFSBox existe
	HFSBoxDir = %lettre%:\HFSBox 
	HFSBoxExist := if InStr(FileExist(HFSBoxDir), "D") 
	
	if (drive != “” && HFSBoxExist)
	{
	;~ On tue HFSSync et Syncthing si ils sont lancés
	Process, Exist, HFSSync.exe
	if ErrorLevel
	{
		Process, Close, HFSSync.exe
		Process, Close, syncthing.exe
	}
	
	;~ On supprime les fichiers de Syncthing
	FileRemoveDir, %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing, 1
	FileRemoveDir, %A_ProgramFiles%\Syncthing, 1
	FileDelete, %A_Startup%\HFS Sync.lnk
	FileDelete, %A_Desktop%\HFSBox.lnk
	FileDelete, %A_Desktop%\HFS Sync.lnk

	
	;~ On supprime la HFSBox
	FileRemoveDir, %lettre%:\HFSBox, 1
	
	msgbox, Vous venez de désinstaller la HFSBox ainsi qu'HFS Sync
	
	GoSub, Suppression
	return
	}

	else
	{
		msgbox, 64, , Aucune installation de la HFSBox detectée`nVeuillez sélectionner un disque valide, merci.
		return
	}
	

	
	Sync:
	GuiControlGet, drive
		if (drive != “”)
	{

	;~ On tue HFSSync et Syncthing si ils sont lancés
	Process, Exist, HFSSync.exe
	if ErrorLevel
	{
		Process, Close, HFSSync.exe
		Process, Close, syncthing.exe
	}
	
	;~ On supprime les fichiers de Syncthing
	FileRemoveDir, %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing, 1
	FileRemoveDir, %A_ProgramFiles%\Syncthing, 1
	FileDelete, %A_Startup%\HFS Sync.lnk
	FileDelete, %A_Desktop%\HFS Sync.lnk
	
	msgbox, Vous venez de désinstaller HFS Sync
	GoSub, Suppression
	return
	}

	else
	{
		msgbox, 64, , Veuillez sélectionner un disque valide, merci.
		return
	}
	
	Rescan:
	GoSub, Etape6
	return

}


;------------------------------------------------------------------------------------------------------------------
; BOUTONS DE L'ETAPE 0
; Bouton pour valider la GUI de verif 64bit
ButtonOui:
{
	Gui, Destroy
	FileInstall, Ressources\syncthing32.exe, %A_Temp%\HFSBoxSync\syncthing.exe
	Goto, Etape1
}

; Bouton pour quitter la GUI de verif 64bit
ButtonNon:
{
	Goto, Suppression
	ExitApp
}
;------------------------------------------------------------------------------------------------------------------


;------------------------------------------------------------------------------------------------------------------
; BOUTONS DE L'ETAPE 0
ButtonCommencer!:
{
GoTo, Etape0
}

; Bouton qui coupe la musique
ButtonSilence:
{
	SoundPlay, Nonexistent.mp3
	return
}

; Bouton qui lance la musique
ButtonMusique!:
{
	SoundPlay, %A_Temp%\HFSBoxSync\HFSBoxMusic.mp3
	return
}

;------------------------------------------------------------------------------------------------------------------
; BOUTONS DE L'ETAPE 1
; Boutton qui ecrase la config et renvoie a l'installation
ButtonRéinstaller:
{
	;~ On tue HFSSync et Syncthing si ils sont lancés
	Process, Exist, HFSSync.exe
	if ErrorLevel
	{
		Process, Close, HFSSync.exe
		Process, Close, syncthing.exe
	}
	
	FileRemoveDir, %HOMEDRIVE%\Users\%A_UserName%\AppData\Local\Syncthing, 1
	Gui, Destroy
	Goto, Etape1
}

; Boutton qui renvoi vers le GUI Désinstallation
ButtonDésinstaller:
{
	Goto, Etape6
}

; Boutton pour quitter l'installation
ButtonQuitter:
{
	Goto, Suppression
	ExitApp
}

; Boutton pour lancer l'installation et generer la liste
ButtonCommencer:
{
	Gui, Destroy
	Goto, Etape2
}

;------------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------------
; BOUTONS DE L'ETAPE 2
; Boutton pour annuler
ButtonAnnuler:
{
	Goto, Suppression
	ExitApp
}

; Boutton pour rescan
ButtonRescan:
{
	GoTo, ButtonCommencer
}
;------------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------------
; BOUTONS ETAPE 4
; Bouton pour copier la clé dans le clipboard
ButtonCopierlaClé:
{
    ; On copie la clef dans le presse-papier
    Clipboard := node_client
	MsgBox, La clé est copiée dans le presse-papiers`nUn fichier text est également disponible sur votre bureau`nCliquez sur Terminer pour finir l'installation
	return
}

; Bouton pour terminer l'installation et lancer la demande
ButtonTerminer:
{
	Gui, Destroy
	MsgBox, La HFSBox sera fonctionnelle une fois la synchronisation terminée
	
	Goto, Suppression
}
;------------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------------
;Fonction pour supprimer le dossier %A_Temp%\HFSBoxSync\ et ses ressources
Suppression:
{
	;On arrete de lire la musique pour permettre sa supression
	SoundPlay, Nonexistent.mp3
	FileRemoveDir, %A_Temp%\HFSBoxSync, 1
	ExitApp
}
;------------------------------------------------------------------------------------------------------------------