function Get-RandomString (
    [int] $minLength = 10,
    [int] $maxLength = $minLength,
    [int] $minUpper = 1,
    [int] $minNumeric = 1,
    [int] $minSymbol = 1,
    [int] $minLower = 1,
    [int] $maxUpper = $maxLength,
    [int] $maxNumeric = $maxLength,
    [int] $maxSymbol = $maxLength,
    [int] $maxLower = $maxLength) {

    $lowercaseSet = 'abcdefghiklmnoprstuvwxyz'.ToCharArray()
    $uppercaseSet = 'ABCDEFGHKLMNOPRSTUVWXYZ'.ToCharArray()
    $numericSet = '1234567890'.ToCharArray()
    $symbolSet = '@#$%^&*-_!+=[]{}|\:,.?/~()'.ToCharArray()

    if ($maxUpper -lt $minUpper) {$minUpper = $maxUpper}
    if ($maxNumeric -lt $minNumeric) {$minNumeric = $maxNumeric}
    if ($maxSymbol -lt $minSymbol) {$minSymbol = $maxSymbol}
    if ($maxLower -lt $minLower) {$minLower = $maxLower}

    # Work out how how long and how many of each character set we are going to choose
    # pick a length between min and max length
    if ($maxLength -gt $minLength) {
        $length = Get-Random -Minimum $minLength -max ($maxLength + 1)
    } else {
        $length = $minLength
    }

    # pick a number of uppercase
    if ($maxUpper -gt $minUpper) {
        if ($maxSymbol -gt 0 -or $maxLower -gt 0 -or $maxNumeric -gt 0) {
            $lengthUpper = get-random -Minimum $minUpper -Maximum ([math]::Min($maxUpper, ($length - $minNumeric - $minSymbol - $minLower)) + 1)
        } else {
            $lengthUpper = $length
        }
    } else {
        $lengthUpper = $minUpper
    }

    # pick a number of numerics
    if ($maxNumeric -gt $minNumeric) {
        if ($maxSymbol -gt 0 -or $maxLower -gt 0) {
            $lengthNumeric = get-random -Minimum $minNumeric -Maximum ([math]::Min($maxNumeric, ($length - $lengthUpper - $minSymbol - $minLower)) + 1)
        } else {
            $lengthNumeric = $length - $lengthUpper
        }
    } else {
        $lengthNumeric = $minNumeric
    }

    # pick a number of symbols
    if ($maxSymbol -gt $minSymbol) {
        if ($maxLower -gt 0) {
            $lengthSymbol = get-random -Minimum $minSymbol -Maximum ([math]::Min($maxSymbol, ($length - $lengthUpper - $lengthNumeric - $minLower)) + 1)
        } else {
            $lengthSymbol = $length - $lengthUpper - $lengthNumeric
        }
    } else {
        $lengthSymbol = $minSymbol
    }

    # pick a number of lowercase
    if ($maxLower -gt $minLower) {
        $lengthLower = $length - $lengthUpper - $lengthNumeric - $lengthSymbol
    } else {
        $lengthLower = $minLower
    }

    # Generate the password character groups
    $password = @()
    if ($lengthUpper -gt 0) { For ($i=1; $i -le $lengthUpper; $i++) { $password += $uppercaseSet | Get-Random } }
    if ($lengthNumeric -gt 0) { For ($i=1; $i -le $lengthNumeric; $i++) { $password += $numericSet | Get-Random } }
    if ($lengthSymbol -gt 0) { For ($i=1; $i -le $lengthSymbol; $i++) { $password += $symbolSet | Get-Random } }
    if ($lengthLower -gt 0) { For ($i=1; $i -le $lengthLower; $i++) { $password += $lowercaseSet | Get-Random } }
 
    # Shuffle the generated password
    $password = [string]::new(($password | Sort-Object {get-random}))

    return $password

}