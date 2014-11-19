@echo off
@setlocal enabledelayedexpansion

FOR /l %%x IN (10,1,254) DO (
	SET ADDR=192.168.137.%%x
	FOR /f %%i in ('ping -n 1 -w 500 !ADDR! ^| find /c "TTL"') DO SET MATCHES=%%i
	IF !MATCHES! EQU 1 (
		ECHO !ADDR! [OK]
		GOTO :eof
	)
)