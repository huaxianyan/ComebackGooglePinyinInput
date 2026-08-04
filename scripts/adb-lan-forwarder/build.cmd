@echo off
setlocal
set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if not exist "%CSC%" (
  echo C# compiler not found.
  exit /b 1
)
"%CSC%" /nologo /target:winexe /optimize+ /out:AdbLanForwarder.exe /reference:System.dll /reference:System.Core.dll /reference:System.Drawing.dll /reference:System.Windows.Forms.dll AdbLanForwarder.cs
if errorlevel 1 exit /b 1
echo Built AdbLanForwarder.exe
