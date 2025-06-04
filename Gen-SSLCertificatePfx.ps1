# Create-Pfx.ps1
param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName
)    

# Prompt for password
$SecurePassword = Read-Host "Please enter the PFX export password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

# Check if openssl exists
if (-not (Get-Command "openssl" -ErrorAction SilentlyContinue)) {
    Write-Error "OpenSSL not found. Please install it and set up the environment variables first."
    exit 1
}

# Prepare command
$cmd = @(
    "pkcs12",
    "-export",
    "-out", "$DomainName.pfx",
    "-inkey", "private.key",
    "-in", "$DomainName.pem",
    "-certfile", "$DomainName.ca",
    "-password", "pass:$PlainPassword"
)

# Execute
Write-Host "`nRunning OpenSSL..."
& openssl $cmd

# Check if file exists and has content
if (Test-Path "$DomainName.pfx" -PathType Leaf) {
    $fileInfo = Get-Item "$DomainName.pfx"
    if ($fileInfo.Length -eq 0) {
        Write-Host "`n❌ Failed, generated PFX file size is 0" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "`n✅ Successfully generated: $DomainName.pfx"
    
    # Validate PFX file using X509Certificate2
    try {
        Write-Host "`nValidating PFX file..."
        $pfxPath = Resolve-Path "$DomainName.pfx" | Select-Object -ExpandProperty Path
        Write-Host "Validation file path: $pfxPath"
        
        $pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($pfxPath, $PlainPassword)
        
        Write-Host "Certificate information:"
        $pfx | Format-List Subject, Issuer, NotBefore, NotAfter, SerialNumber, Thumbprint
        
        if ($pfx.HasPrivateKey) {
            Write-Host "✅ Certificate contains private key"
        } else {
            Write-Host "❌ Certificate does not contain private key" -ForegroundColor Red
        }
        
        Write-Host "`n✅ PFX file validation successful"
    }
    catch {
        Write-Host "`n❌ PFX file validation failed: $_" -ForegroundColor Red
    }
} else {
    Write-Host "`n❌ Failed, please check if the file path and format are correct" -ForegroundColor Red
}