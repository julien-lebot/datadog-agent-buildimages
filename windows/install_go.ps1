$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Write-Host -ForegroundColor Green "Installing go $ENV:GO_VERSION"

$gozip = "https://dl.google.com/go/go$ENV:GO_VERSION.windows-amd64.zip"

$out = 'go.zip'

Write-Host -ForegroundColor Green "Downloading $gozip to $out"

(New-Object System.Net.WebClient).DownloadFile($gozip, $out)
if ((Get-FileHash -Algorithm SHA256 $out).Hash -ne "$ENV:GO_SHA256") { Write-Host \"Wrong hashsum for ${out}: got '$((Get-FileHash -Algorithm SHA256 $out).Hash)', expected '$ENV:GO_SHA256'.\"; exit 1 }

Write-Host -ForegroundColor Green "Extracting $out to c:\"

Start-Process "7z" -ArgumentList 'x -oc:\ go.zip' -Wait

Write-Host -ForegroundColor Green "Removing temporary file $out"

Remove-Item $out

setx GOROOT c:\go
$Env:GOROOT="c:\go"
setx PATH "$Env:Path;c:\go\bin;"
$Env:Path="$Env:Path;c:\go\bin;"

Write-Host -ForegroundColor Green "Installed go $ENV:GO_VERSION"

