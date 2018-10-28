#Password generator modified from Steve König http://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
#Get random characters function
function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
#Scramble the string of characters function
function Scramble([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

#Password length and complexity can be adjusted by adjusting the length parameter in the next four commands

#Get four lower case (removed the "l" and "o" to prevent confusion)
$password = Get-RandomCharacters -length 4 -characters 'abcdefghikmnoprstuvwxyz'

#Get two upper case (removed the "O" toi prevent confusion)
$password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNPRSTUVWXYZ'

#Get two numbers (removed the "0" and "1" to prevent confusion)
$password += Get-RandomCharacters -length 2 -characters '23456789'

#Get two special characters (removed a few problem characters such as "$")
$password += Get-RandomCharacters -length 2 -characters '!%&()=?}][{@#*+'

$password = Scramble $password

Write-Host $password