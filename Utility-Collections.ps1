function Get-CollectionPropertyNames ($collection) {
    $names = new-object System.Collections.ArrayList

    foreach ($object in $collection) {
        $objectProperties = $object | get-member -MemberType Property,NoteProperty | select -ExpandProperty Name
        if ($objectProperties) {
            $differences = Compare-Object -ReferenceObject $names -DifferenceObject $objectProperties | where {$_.SideIndicator -eq "=>"} | select -ExpandProperty InputObject
            if ($differences.count -eq 1) {
                $null = $names.Add($differences)
            } elseif ($differences.count -gt 1) {
                $null = $names.AddRange($differences)
            }
        }
    }

    return $names
}

function Flatten-Object ($object) {

    $return = $null

    switch ($true) {
        ($object -is [System.Collections.IDictionary]) {
            foreach ($key in $object.keys) {
                if ($return) { $return += ";"}
                $return += "$key=$($object.$key)"
            }
            break
        }
        ($object -is [System.Collections.ICollection]) {
            foreach ($item in $object) {
                if ($return) { $return += ";"}
                $return += $item.tostring()
            }
            break
        }
        ($object -is [PSCustomObject]) {
            $return = $object | ConvertTo-Json -Depth 1
            break
        }
        ($object -and $object.Gettype().Isclass) {
            $newObject = new-object hashtable
            $properties = $object | get-member -MemberType Property,NoteProperty | select -ExpandProperty Name

            foreach ($property in $properties) {
                $value = Flatten-Object -object $object.$property
                $newobject | Add-Member -MemberType "NoteProperty" -Name $property -value $value
            }

            $return = $newobject
            break
        }
        default {
            $return = $object
        }
    }

    return $return
}