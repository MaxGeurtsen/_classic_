$f = "C:\Program Files (x86)\World of Warcraft\_classic_\WTF\Account\SANDERDEBESTE\SavedVariables\InstanceBoostTracker.lua"

[string]$gcf = gc $f
$gcf = $gcf.Replace('["', '"')
$gcf = $gcf.Replace("[", '"')
$gcf = $gcf.Replace('"]', '"')
$gcf = $gcf.Replace("]", '"')
$gcf = $gcf.Replace("=", ":")
$gcf = $gcf.Replace('SavedCharacterLockouts', ',SavedCharacterLockouts')
$gcf = $gcf.Replace('SavedStatistics', ',SavedStatistics')
$gcf = $gcf.Replace('SpeedyAutoLootDB', ',SpeedyAutoLootDB')
$gcf = "{" + $gcf + "}"

$gcf | Out-File -FilePath "C:\Temp\Jsontest.json" # Parse this file in an online json formatter and download output https://jsonformatter.curiousconcept.com/#
$parsedJson = Get-Content "C:\Users\svdho\Downloads\data.json" -Raw
$json = ConvertFrom-Json -InputObject $parsedJson

$character = "Okrah"

$instanceCountDict = @{}
$instanceIds = $json.SavedAccountLockouts.psobject.Members.Name
foreach ($instanceId in $instanceIds) {

    $lockout = $json.SavedAccountLockouts.$instanceId
    if ($lockout.playerName -eq $character) {
        $instanceCountDict[$lockout.instanceName] += 1
    }

}

$instanceCountDict.GetEnumerator() | Sort-Object -Property "Name"