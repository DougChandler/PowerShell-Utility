Function Convert-HexToBytes {
    <#
    .SYNOPSIS
    Converts a string of hex characters to a byte array.
    
    .DESCRIPTION
    Takes in a string of hex characters and returns the byte array that the
    hex represents.
    
    .PARAMETER Value
    [String] The hex string to convert.

    .OUTPUTS
    [byte[]] The byte array based on the converted hex string.
    
    .EXAMPLE
    Convert-HexToBytes -Value "48656c6c6f20576f726c64"
    
    .NOTES
    The hex string should have no spaces that separate each hex char.
    #>
    [CmdletBinding()]
    [OutputType([byte[]])]
    param(
        [Parameter(Mandatory=$true)] [String]$Value
    )
    $bytes = New-Object -TypeName byte[] -ArgumentList ($Value.Length / 2)
    for ($i = 0; $i -lt $Value.Length; $i += 2) {
        $bytes[$i / 2] = [Convert]::ToByte($Value.Substring($i, 2), 16)
    }

    return [byte[]]$bytes
}

Function Convert-BytesToHex {
    <#
    .SYNOPSIS
    Converts a byte array to a string of hex characters.
 
    .DESCRIPTION
    Takes in a byte array and returns the hex string representation of each
    byte.
 
    .PARAMETER Value
    [byte[]] The byte array to create the hex string from.
 
    .RETURNS HexString
    [String] The hex string of the byte array.
 
    .EXAMPLE
    Convert-BytesToHex -Value [byte[]]@(72, 101, 108, 108, 111)
 
    .NOTES
    No special notes.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param(
        [Parameter(Mandatory=$true)] [byte[]]$Value
    )
    $hex_string = New-Object -TypeName System.Text.StringBuilder -ArgumentList ($Value.Length * 2)
    foreach ($byte in $Value) {
        $hex_string.AppendFormat("{0:x2}", $byte) > $null
    }

    return $hex_string.ToString()
}
