function New-Selection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=1)] [object] $Value,
        [Parameter()] [char]   $Char,
        [Parameter()] [string] $Label
    )
    
    if (-not $Char) {
        $Char = $Value.ToString().ToLower()[0]
        if (-not $Char) { throw "Char required" }
    }
    if (-not $Label) {
        $Label = $Value.ToString()
        if (-not $Label) { throw "Label required" }
    }

    return [Selection]@{
        Value = $Value
        Char  = $Char
        Label = $Label
    }
}