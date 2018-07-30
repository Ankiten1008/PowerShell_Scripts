<#
.Synopsis
   Bulk Add Users to AD Groups
.DESCRIPTION
   Takes a plain text one-per-line list of Active Directory user identity names/logon names and adds then to one or more specified groups
.EXAMPLE
   .\bulk_add_users.ps1 "C:\identities.txt" "SECURITY-GROUP-FOO,SECURITY-GROUP-BAR"
.PARAMETER user_list
    Full path of the text file containing a one-per-line list of Active Directory user identity names. Required.
.PARAMETER target_groups
    A single string containing a comma-separated list of all groups to which the users should be added.    

#>

param(   
    [parameter(mandatory=$true,Position=1)]
    [ValidateNotNullOrEmpty()]    
        [string]$user_list=$(throw "user_list must have the path of a text file containing users to be added."),
    [parameter(mandatory=$true,Position=2)]
    [ValidateNotNullOrEmpty()] 
        [string]$target_groups=$(throw "target_groups must contain at least one valid Active Directory Security Group name. Separate each group with a comma.")
)


$target_groups_clean = $target_groups.Replace(' ','')
#remove inconsistent spacing. array Count function will return the correct n count of elements. 

$target_groups_array = $target_groups_clean.Split(',')
#array should be clean


$user_collection = Get-Content $user_list | % {Get-ADUser $_ }


$target_groups_array | %{ Add-ADGroupMember -Identity $_ -Members $user_collection}

