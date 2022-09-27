function Get-Selection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=1, ValueFromPipeline)] [Selection[]] $Selections,
        [Parameter()] [switch] $Cancel = $false,
        [Parameter()] [switch] $Quit = $false
    )
    
    begin {
        $AllSelections = @()
    }
    
    process {
        $AllSelections += $Selections
    }
    
    end {

        if ($Cancel) {
            $AllSelections += [Selection]@{
                Value = 'cancel'
                Char = 'c'
                Label = "Cancel"
            }
        }
        if ($Quit) {
            $AllSelections += [Selection]@{
                Value = 'quit'
                Char = 'q'
                Label = "Quit"
            }
        }

        if ([bool]($AllSelections | Group-Object -Property Char | Where-Object -Property Count -GT -Value 1)) { throw "ERROR: Duplicate char" }
        if ([bool]($AllSelections | Group-Object -Property Label | Where-Object -Property Count -GT -Value 1)) { throw "ERROR: Duplicate label" }

        foreach ($Option in $AllSelections) { Write-Host ("[ $($Option.Char.ToString().ToUpper()) ]  $($Option.Label)") }

        Write-Host ""
        Write-Host "Please select an option: " -NoNewline

        while ($true) {
            $Char = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
            $Selected = $AllSelections | Where-Object -Property Char -EQ -Value $Char
            if ($Selected) {
                Write-Host $Selected.Char.ToString().ToUpper()
                Write-Host ""
                return $Selected.Value
            }
        }
    }
}