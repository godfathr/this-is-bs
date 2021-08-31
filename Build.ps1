[CmdLetBinding()]
param(
    [Parameter()]
    [string]$Watch = 'false'
)
# ******************************************************************
# Argument values
# ******************************************************************
# "Working directory argument: " 

if ($Watch -ne $true) {
    "SASS Watch argument: " 
    Write-Host $Watch
}

# ******************************************************************
# Common functions
# ******************************************************************
function WriteSeparatorToOutput() {
    Write-Host "`n********************************************************************"
    Write-Host "`n"
    Write-Host "`n********************************************************************"
}

function GetAndPrintTimeStamp ([string]$step) {
    $timestamp = Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss.fff K"
    Write-Host "$step... $timestamp"
}

# ******************************************************************
# Set initial location
# ******************************************************************
Pop-Location
Push-Location .\src

# ******************************************************************
# npm install
# ******************************************************************
if ($Watch -ne 'true' -And $Theme -eq 'all') {
    WriteSeparatorToOutput
    Pop-Location
    Push-Location .\src\themes
    GetAndPrintTimeStamp("Begin npm install")

    if ($PipelineBuild) {
        Write-Host "npm install sass -g"
        npm install
        npm install sass -g
    }
    else {
        Write-Host "npm install sass"
        npm install
        npm install sass
    }

    GetAndPrintTimeStamp("End npm install")
}

# ******************************************************************
# SASS Compile
# ******************************************************************
WriteSeparatorToOutput
Pop-Location
Push-Location .\src\themes\styleguide\assets\styles
GetAndPrintTimeStamp("Start compile themes")

npm install sass

Write-Host "Single theme = $Theme"
Pop-Location

# dotnet stop

# Need to stringify the SASS arguments. If we don't, the compiler 
# throws the error --watch is not allowed when printing to stdout.
$themeSource = ".\src\themes\styleguide\assets\styles\" + "$theme.scss"
$themeName = $theme
$themeNameAndPath = ".\src\wwwroot\generatedStyles\" + "$themeName.css"

Pop-Location
Push-Location .\src\
Write-Host "dotnet run"
dotnet run

Write-Host "ThemeName = $themeName"
Write-Host "sass --watch --style=expanded --no-source-map $themeSource $themeNameAndPath"
    
sass --watch --style=expanded --no-source-map $themeSource $themeNameAndPath

GetAndPrintTimeStamp("Finish compile themes")

Write-Host "`n********************************************************************"
Write-Host "`n"
Write-Host "`n"