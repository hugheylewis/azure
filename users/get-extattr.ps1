do {
    $inputPath = Read-Host "Enter filepath to read from"
    if ($inputPath -eq 'exit') { exit }
} while (-not (Test-Path $inputPath))

do {
    $outputPath = Read-Host "Enter filepath to write to"
    if ($outputPath -eq 'exit') { exit }
} while ([string]::IsNullOrWhiteSpace($outputPath))

do {
    $extattr = Read-Host "Enter extension attribute number to retrieve"
    if ($extattr -eq 'exit') { exit }
} while ([string]::IsNullOrWhiteSpace($extattr))

$rawUpns = Get-Content $inputPath
$rawUpns = $rawUpns | Select-Object -Skip 1
$extattr = "extensionAttribute" + $extattr.ToString()
$results = @()

Connect-MgGraph -Scopes "User.Read.All"

foreach ($upn in $rawUpns) {
    $ext5 = (Get-MgUser -UserId $upn -Property onPremisesExtensionAttributes).onPremisesExtensionAttributes.$extattr
    $results += [PSCustomObject]@{
            UPN                 = $upn
            $extattr = $ext5
    }
}

$results | Export-Csv $outputPath -NoTypeInformation
