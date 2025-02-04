$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host -ForegroundColor Green Installing Google Cloud SDK
$version = "315.0.0"
$gsdk = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$version-windows-x86_64.zip"
$out = 'gsdk.zip'
$sha256 = "c9b283c9db4ed472111ccf32e6689fd467daf18ce3a77b8e601f9c646a83d86b"

Write-Host -ForegroundColor Green Downloading $gsdk to $out
(New-Object System.Net.WebClient).DownloadFile($gsdk, $out)
if ((Get-FileHash -Algorithm SHA256 $out).Hash -ne "$sha256") { Write-Host \"Wrong hashsum for ${out}: got '$((Get-FileHash -Algorithm SHA256 $out).Hash)', expected '$sha256'.\"; exit 1 }

Get-ChildItem $out

# write file size to make sure it worked
Write-Host -ForegroundColor Green "File size is $((get-item $out).length)"

Expand-Archive gsdk.zip -DestinationPath C:
Remove-Item $out

# add to path
$pwd = pwd
setx PATH "$Env:Path;$pwd\google-cloud-sdk\bin"
$Env:Path="$Env:Path;$pwd\google-cloud-sdk\bin"

Write-Host -ForegroundColor Green Done Installing Google Cloud SDK
