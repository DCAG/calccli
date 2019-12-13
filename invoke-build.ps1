
### Build using Psake

Invoke-Psake .\build.psake.ps1
Invoke-Psake .\build.psake.ps1 -tasklist init


### Build using MSBuild

$MSBuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe'

& $MSBuild .\build.proj