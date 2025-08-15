@echo off
title Painel de Suporte Tecnico - Limpeza e Solucoes
color 7D

:MENU
cls
echo =====================================================
echo        CRIADO POR WAGNER MERCES e IURY DUFFES
echo            FERRAMENTA PARA USO DO TECNICO    
echo        UTILIZE A FERRAMENTA COMO ADMINISTRADOR     
echo =====================================================
echo.
echo [1] Limpeza de arquivos temporarios
echo [2] Executar limpeza de disco (cleanmgr)
echo [3] Verificacao de arquivos do sistema (SFC)
echo [4] Reparo da imagem do Windows (DISM)
echo [5] Reset do Windows Update
echo [6] Reset de configuracoes de rede
echo [7] Atualizacao das politicas de grupo (GPO)
echo [8] Limpeza de logs de eventos
echo [9] Informacoes do sistema (msinfo32)
echo [10] Gerenciador de dispositivos
echo [11] Ver adaptadores de rede
echo [12] Ver programas instalados
echo [13] Ver processos em execucao
echo [14] Ver status dos principais servicos
echo [15] Executar CHKDSK no disco C:
echo [16] Abrir PowerShell
echo [17] Verificar ipconfig
echo [18] Instalar impressora / Abrir link de driver
echo [19] Abertura de chamado
echo [20] Testar velocidade da internet 
echo [21] Verificar espaco em disco
echo [22] Verificar status do antivirus
echo [23] Testar conectividade com o google
echo [24] Backup dos logs de eventos
echo [25] Visualizar dispositivos USB conectados
echo [26] Ver uso de memoria e CPU
echo [0] Sair
echo.
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="1" goto TEMP
if "%opcao%"=="2" goto DISK
if "%opcao%"=="3" goto SFC
if "%opcao%"=="4" goto DISM
if "%opcao%"=="5" goto UPDATE
if "%opcao%"=="6" goto NET
if "%opcao%"=="7" goto GPO
if "%opcao%"=="8" goto LOGS
if "%opcao%"=="9" start msinfo32 & goto MENU
if "%opcao%"=="10" start devmgmt.msc & goto MENU
if "%opcao%"=="11" start ncpa.cpl & goto MENU
if "%opcao%"=="12" start appwiz.cpl & goto MENU
if "%opcao%"=="13" tasklist & pause & goto MENU
if "%opcao%"=="14" goto SERVICOS
if "%opcao%"=="15" goto CHKDSK
if "%opcao%"=="16" start powershell & goto MENU
if "%opcao%"=="17" goto IPCONFIG
if "%opcao%"=="18" goto OKI
if "%opcao%"=="19" start https://dufryprod.service-now.com/dufry_sp?id=sub_ticket & goto MENU
if "%opcao%"=="20" start https://www.fast.com & goto MENU
if "%opcao%"=="21" goto DISKSPACE
if "%opcao%"=="22" goto ANTIVIRUS
if "%opcao%"=="23" goto PING
if "%opcao%"=="24" goto BACKUPLOGS
if "%opcao%"=="25" goto USB
if "%opcao%"=="26" goto RECURSOS
if "%opcao%"=="0" exit
goto MENU

:TEMP
cls
echo Limpando arquivos temporarios...
del /s /f /q "%TEMP%\*"
del /s /f /q "C:\Windows\Temp\*"
echo Concluido.
pause
goto MENU

:DISK
cls
echo Executando limpeza de disco...
cleanmgr /sagerun:1
pause
goto MENU

:SFC
cls
echo Executando verificacao do sistema (SFC)...
sfc /scannow
pause
goto MENU

:DISM
cls
echo Executando DISM...
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto MENU

:UPDATE
cls
echo Resetando componentes do Windows Update...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo Concluido.
pause
goto MENU

:NET
cls
echo Resetando configuracoes de rede...
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh winsock reset
netsh int ip reset
pause
goto MENU

:GPO
cls
echo Atualizando politicas de grupo...
gpupdate /force
pause
goto MENU

:LOGS
cls
echo Limpando logs de eventos...
for /F "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1"
echo Concluido.
pause
goto MENU

:SERVICOS
cls
echo Verificando status de servicos principais...
sc query wuauserv
sc query bits
sc query dhcp
sc query dnscache
sc query nlasvc
sc query netprofm
pause
goto MENU

:CHKDSK
cls
echo Executando CHKDSK no disco C:
chkdsk C: /f /r
pause
goto MENU

:IPCONFIG
cls
echo Exibindo informacoes de IP...
ipconfig
pause
goto MENU

:OKI
cls
echo Abrindo pasta de instalacao da impressora OKI...
start \\brprt001
echo Selecione o driver ou instalador da impressora OKI conforme necessário.
pause
goto MENU

:DISKSPACE
cls
echo Verificando espaço em disco...
wmic logicaldisk get name,freespace,size
pause
goto MENU

:ANTIVIRUS
cls
echo Verificando status do Windows Defender...
powershell -command "Get-MpComputerStatus | Select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled"
pause
goto MENU

:PING
cls
echo Testando conectividade com Google...
ping www.google.com
pause
goto MENU

:BACKUPLOGS
cls
echo Criando backup dos logs de eventos...
mkdir C:\BackupLogs
wevtutil epl Application C:\BackupLogs\Application.evtx
wevtutil epl System C:\BackupLogs\System.evtx
echo Backup concluido em C:\BackupLogs
pause
goto MENU

:USB
@echo off
cls
echo Verificando dispositivos USB conectados...
REM Verifica se há dispositivos USB conectados
wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description | findstr /i "USB" >nul
if %errorlevel%==0 (
    echo Dispositivos USB conectados:
    wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description
) else (
    echo Nenhum dispositivo USB encontrado.
)
pause
goto MENU



:RECURSOS
cls
echo Monitorando uso de recursos...
start taskmgr
goto MENU
