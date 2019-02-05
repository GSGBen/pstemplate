# PSTemplate

Use and fill templates in PowerShell via a simple syntax.

## Installation

```powershell
Install-Module PSTemplate
```

## Usage

### One-liner

```powershell
Fill-Template -Template "simple {{Type}} but could be a here-string" -Variables @{'Type' = 'string'}
```
outputs:
```
simple string but could be a here-string
```
### More Common

```powershell
$template = @"
{{line1}}
line2
{{line3}}
"@

$tokens = @{
    "line1" = "Line 1"
    "line3" = "Line 3"
}

Fill-Template -Template $template -Variables $tokens
```
outputs:
```
Line 1
line2
Line 3
```

### From and to File

```powershell
$tokens = @{
    "line1" = "Line 1"
    "line3" = "Line 3"
}

Get-Content "C:\temp\Lines.template" | Fill-Template -Template $template -Variables $tokens | Out-File "C:\temp\lines.filled" -Encoding Utf8
```