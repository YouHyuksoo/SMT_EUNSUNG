@echo off 
cd C:\D\Project\Infinity21 PDA Barcode\PBL Library 10.5
ftp -i -n -v 192.168.100.2 < C:\D\Project\Infinity21 PDA Barcode\PBL Library 10.5\ftp_para.cfg 
if not errorlevel 0 goto :err 
echo Success > C:\D\Project\Infinity21 PDA Barcode\PBL Library 10.5\logger.dat 
:err 
echo Fail > C:\D\Project\Infinity21 PDA Barcode\PBL Library 10.5\logger.dat 
:end 
echo on 
