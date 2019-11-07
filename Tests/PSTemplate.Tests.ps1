Import-Module "..\PSTemplate" -Force -DisableNameChecking

$MultilineStringTemplate = @"
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


Describe "Fill-Template" {

    It "replaces all {{<>}} tokens in a single multi-line string with values in a hash table that contains all tokens as keys" {
        Fill-Template -Template $MultilineStringTemplate -Variables $HashTableWithAllKeys | Should Be $MultilineStringFullyFilled
    }

    It "replaces some {{<>}} tokens in a single multi-line string with values in a hash table that contains some tokens as keys" {
        Fill-Template -Template $MultilineStringTemplate -Variables $HashTableWithLessKeys | Should Be $MultilineStringLessFilled
    }

    It "replaces all {{<>}} tokens in a single single-line string with values in a hash table that contains all tokens as keys" {
        Fill-Template -Template $SingleLineStringTemplate -Variables $HashTableWithAllKeys | Should Be $SingleLineStringFullyFilled
    }

    It "replaces some {{<>}} tokens in a single single-line string with values in a hash table that contains some tokens as keys" {
        Fill-Template -Template $SingleLineStringTemplate -Variables $HashTableWithLessKeys | Should Be $SingleLineStringLessFilled
    }

}