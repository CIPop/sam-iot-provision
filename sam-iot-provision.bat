SET cloud=%1
SET wincver=%2
SET comport=%3
SET drive=%4
SET DIR_UPGRADER=SAM_IoT_WINC_Upgrader
SET DIR_CERTGEN=SAM_IoT_Certs_Generator\CertGen

REM *** Programming Serial Bridge Firmware ***
copy .\%DIR_UPGRADER%\sam_iot_serial_bridge.hex %drive%:\

REM *** Launching WINC Programming Tool ***
cd .\%DIR_UPGRADER%\%wincver%
CALL download_all.bat UART SAMD21 3A0 0 %comport%

@ECHO on

REM *** Programming Provisioning Firmware ***
cd ..\..\%DIR_CERTGEN%
copy SAM_IoT_CertGen.hex %drive%:\

REM *** Updating Python Modules ***
python -m pip install --upgrade pip
pip install -r py_modules.txt

REM *** Generating Device Certificate ***
REM *** Writing Certificates to WINC1510 ***
cd ..
CALL python provision_samiot.py com%comport%

REM *** Programming Cloud Service Demo Application ***
cd ..\..
IF %cloud%==azure copy AzureIotPnpDps.X.production.hex %drive%:\