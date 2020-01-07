Import-Module "$PSScriptRoot\..\PSTemplate" -Force -DisableNameChecking

#region----------TEST DATA

    $MultilineStringTemplate = @"
line 1: {{Token1}}
line 2: {{Token2}}
"@

    $MultilineStringWithBlanksTemplate = @"
line 1: {{Token1}}

line 2: {{Token2}}
"@

    $HashTableWithAllKeys = @{
        Token1 = "Value1"
        Token2 = "Value2"
    }

    $MultilineStringFullyFilled = @"
line 1: Value1
line 2: Value2
"@

    $MultilineStringWithBlanksFullyFilled = @"
line 1: Value1

line 2: Value2
"@

    $HashTableWithLessKeys = @{
        Token1 = "Value1"
    }

    $MultilineStringLessFilled = @"
line 1: Value1
line 2: {{Token2}}
"@

    $SingleLineStringTemplate = "Token 1: {{Token1}}; Token 2: {{Token2}}"
    $SingleLineStringFullyFilled = "Token 1: Value1; Token 2: Value2"
    $SingleLineStringLessFilled = "Token 1: Value1; Token 2: {{Token2}}"

    $MultiLineTextFileTemplate = Get-Content "$PSScriptRoot\MultilineTextFile.template"
    $MultiLineTextFileFullyFilled = Get-Content "$PSScriptRoot\MultilineTextFile.FullyFilled"
    $MultiLineTextFileWithBlanksTemplate = Get-Content "$PSScriptRoot\MultilineTextFileWithBlanks.template"
    $MultiLineTextFileWithBlanksFullyFilled = Get-Content "$PSScriptRoot\MultilineTextFileWithBlanks.FullyFilled"
    $MultiLineTextFileLessFilled = Get-Content "$PSScriptRoot\MultilineTextFile.LessFilled"
        
#endregion-------

#region----------TESTS

Describe "Invoke-PSTemplate" {

    Context "Multi-line string" {

        It "replaces all {{<>}} tokens in a single multi-line string with values in a hash table that contains all tokens as keys" {
            Invoke-PSTemplate -Template $MultilineStringTemplate -Variables $HashTableWithAllKeys | Should Be $MultilineStringFullyFilled
        }

        It "replaces all {{<>}} tokens in a single multi-line string, including blank lines, with values in a hash table that contains all tokens as keys" {
            Invoke-PSTemplate -Template $MultilineStringWithBlanksTemplate -Variables $HashTableWithAllKeys | Should Be $MultilineStringWithBlanksFullyFilled
            {Invoke-PSTemplate -Template $MultilineStringWithBlanksTemplate -Variables $HashTableWithAllKeys} | Should Not Throw
        }
    
        It "replaces some {{<>}} tokens in a single multi-line string with values in a hash table that contains some tokens as keys" {
            Invoke-PSTemplate -Template $MultilineStringTemplate -Variables $HashTableWithLessKeys | Should Be $MultilineStringLessFilled
        }

        It "returns an array of the same size as the input" {
            (Invoke-PSTemplate -Template $MultilineStringTemplate -Variables $HashTableWithAllKeys).Count | Should Be $MultilineStringTemplate.Count
        }
    }

    Context "Single-line string"{

        It "replaces all {{<>}} tokens in a single single-line string with values in a hash table that contains all tokens as keys" {
            Invoke-PSTemplate -Template $SingleLineStringTemplate -Variables $HashTableWithAllKeys | Should Be $SingleLineStringFullyFilled
        }

        It "replaces some {{<>}} tokens in a single single-line string with values in a hash table that contains some tokens as keys" {
            Invoke-PSTemplate -Template $SingleLineStringTemplate -Variables $HashTableWithLessKeys | Should Be $SingleLineStringLessFilled
        }

        It "returns an array of the same size as the input" {
            (Invoke-PSTemplate -Template $SingleLineStringTemplate -Variables $HashTableWithAllKeys).Count | Should Be $SingleLineStringFullyFilled.Count
        }
    }

    Context "Multi-line text file" {

        It "replaces all {{<>}} tokens in a single multi-line text file with values in a hash table that contains all tokens as keys" {
            Invoke-PSTemplate -Template $MultiLineTextFileTemplate -Variables $HashTableWithAllKeys | Should Be $MultiLineTextFileFullyFilled
        }

        It "replaces all {{<>}} tokens in a single multi-line text file, including blank lines, with values in a hash table that contains all tokens as keys" {
            # pester 3 is funky with arrays, blank entries and pipes. As we're explictly testing blank lines in an array here, we need to deal with it
            # instead of comparing the arrays, join the arrays in the same way. They should then be the same if the original arrays were the same
            $Filled = Invoke-PSTemplate -Template $MultiLineTextFileWithBlanksTemplate -Variables $HashTableWithAllKeys
            $FilledJoined = $Filled -join "`n"
            $TargetJoined = $MultiLineTextFileWithBlanksFullyFilled -join "`n"
            $FilledJoined | Should Be $TargetJoined

            $Filled.Count | Should Be $MultiLineTextFileWithBlanksFullyFilled.Count

            {Invoke-PSTemplate -Template $MultiLineTextFileWithBlanksTemplate -Variables $HashTableWithAllKeys} | Should Not Throw
        }

        It "replaces some {{<>}} tokens in a single multi-line text file with values in a hash table that contains some tokens as keys" {
            Invoke-PSTemplate -Template $MultiLineTextFileTemplate -Variables $HashTableWithLessKeys | Should Be $MultiLineTextFileLessFilled
        }
        
        It "returns an array of the same size as the input" {
            (Invoke-PSTemplate -Template $MultiLineTextFileTemplate -Variables $HashTableWithAllKeys).Count | Should Be $MultiLineTextFileTemplate.Count
        }
    }

} 

Describe "Fill-Template" {

    It "is an alias of Invoke-PSTemplate" {
        (get-alias -Name "Fill-Template").ReferencedCommand.Name | Should Be "Invoke-PSTemplate"
    }

    It "has the same functionality as Invoke-PSTemplate (replaces all {{<>}} tokens in a single multi-line string with values in a hash table that contains all tokens as keys)" {
        Fill-Template -Template $MultilineStringTemplate -Variables $HashTableWithAllKeys | Should Be $MultilineStringFullyFilled
    }

}

#endregion-------