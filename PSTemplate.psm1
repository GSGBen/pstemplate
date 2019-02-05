<#
.synopsis
    - Fills out a template filled with {{name}} variables using a hash table
.description
    - Template should be formatted as a string, with {{<VariableName>}} used as the tokens to replace
    - Replacements should be in a hash table as {{<VariableName>}} = ReplacementValue
.example
    - Fill-Template -Template "simple {{Type}} but could be a here-string" -Variables @{'Type' = 'string'}
    - returns: simple string but could be a here-string 
.parameter Template
    - the template in the form of a string
.parameter Variables
    - the variable key-value pairs to replace
.outputs
    - returns the input Template form with the replacements applied
.notes
    Author: Ben Renninson
    Email: ben@goldensyrupgames.com
    From: https://github.com/GSGBen/PSTemplate
#>
function Fill-Template
{
    Param
    (
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Template,
        [Parameter(Position=1,Mandatory=$true)][System.Collections.IDictionary]$Variables
    )

    $Return = $Template

    $Variables.GetEnumerator() | Select-Object Name,Value | ForEach-Object {
        $Return = $Return.Replace("{{$($_.Name)}}",$_.Value)
    }

    return $Return
}