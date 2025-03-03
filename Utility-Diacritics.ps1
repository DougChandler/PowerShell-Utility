function Import-UnicodeMappingTable ([string] $unicodeMapFolderName, [string] $unicodeMapFileName = "UnicodeAsciiMap.json") {

    
    if ($unicodeMapFolderName) {
        $path = $Global:scriptsFolder + "\$unicodeMapFileName"
    } elseif ($Global:scriptsFolder) {
        $path = $Global:scriptsFolder + "\$unicodeMapFileName"
    } else {
        $path = $Global:scriptsFolder + ".\$unicodeMapFileName"
    }

    if (test-path -path $path) {
        try {
            $global:UnicodeAsciiMap = get-content -Path $path | ConvertFrom-Json -AsHashtable
        }
        catch {
            throw "Cannot load Unicode Mapping File ($_.Exception.Message)"
        }
    } else {
        throw "Cannot find Unicode Mapping File ($path)"
    }
    
}

function Remove-Diacritics ([String] $source) {

    $return = $null

    # Iterate through the source string and examine each character, if it is not ascii, lookup a replacement character in the map
    if ($null -ne $source) {
        $sb = new-object System.Text.StringBuilder
        $source.EnumerateRunes().ForEach({
            if ($_.IsAscii) {
                [void]$sb.Append($_.ToString())
            }
            else {
                [void]$sb.Append($global:UnicodeAsciiMap[[String]$_.Value])
            }
        })
        $return = $sb.ToString()
    }

    return $return
}
