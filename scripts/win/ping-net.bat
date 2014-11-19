@echo off
@setlocal enabledelayedexpansion

FOR /l %%x IN (1,1,20) DO (
	SET ADDR=192.168.1.%%x
	FOR /f %%i in ('ping -n 1 -w 500 !ADDR! ^| find /c "TTL"') DO SET MATCHES=%%i
	IF !MATCHES! EQU 1 ECHO !ADDR! [OK]
)