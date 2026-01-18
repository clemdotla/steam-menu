$existingFunctions = Get-ChildItem Function: | Select-Object -ExpandProperty Name
# --------------


$plugins = Join-Path $steam "plugins"
if (!(Test-Path $plugins)) { New-Item -Path $plugins -ItemType Directory }

$name = "luatools"
$link = "https://github.com/madoiscool/ltsteamplugin/releases/latest/download/ltsteamplugin.zip"


function _FindPlugin() {
    foreach ($plugin in Get-ChildItem -Path $plugins -Directory) {
        $jsonFile = Join-Path $plugin.FullName "plugin.json"
        if (Test-Path $jsonFile) {
            $json = Get-Content $jsonFile -Raw | ConvertFrom-Json
            if ($json.name -eq $name) {
                return $plugin.FullName
            }
        }
    }
}


function Install-plugin() {

}
function Uninstall-plugin() {
    $plugin = _FindPlugin
    if ($plugin) {
        Remove-Item $plugin -Recurse -Force
        Log "INFO" $(Strings("plugin-uninstalled"))
    }

    Log "LOG" $(Strings("uninstall-millennium"))
    $res = HandleMenu @("yes", "no") $false
    if ($res -eq "yes") {
        Import "menu\manage-millennium.psm1"
        Uninstall-millennium
    }

    Log "LOG" $(Strings("uninstall-steamtools"))
    $res = HandleMenu @("yes", "no") $false
    if ($res -eq "yes") {
        Import "menu\manage-steamtools.psm1"
        Uninstall-steamtools
    }
}



function Invoke-manageplugin() {
    $res = HandleMenu @("install", "uninstall", "return-menu")

    if ($res -eq "return-menu") { return }
    if ($res -eq "install") { Install-plugin }
    if ($res -eq "uninstall") { Uninstall-plugin }
}



# Exports
$publicFunctions = (Get-ChildItem Function: | Select-Object -ExpandProperty Name) | Where-Object { ($_ -notin $existingFunctions) -and ($_ -notlike "_*") }
Export-ModuleMember -Function $publicFunctions