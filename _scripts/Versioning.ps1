
$targetFiles=
    @("$PSScriptRoot'\..\UpdateProductVersion.targets")

function IncreaseMajor(){
    [CmdletBinding()]
    Param(

        [Parameter(Position=0, Mandatory=$true)]
        [string] $file
    )

    UpdateVersion $file { param($oldVersion) New-Object System.Version -ArgumentList ($oldVersion.Major+1), 0, 0 }
}

function IncreaseMinor(){
    [CmdletBinding()]
    Param(

        [Parameter(Position=0, Mandatory=$true)]
        [string] $file
    )

    UpdateVersion $file { param($oldVersion) New-Object System.Version -ArgumentList $oldVersion.Major, ($oldVersion.Minor+1), 0 }
}

function IncreaseBuild(){
    [CmdletBinding()]
    Param(

        [Parameter(Position=0, Mandatory=$true)]
        [string] $file
    )

    UpdateVersion $file { param($oldVersion) New-Object System.Version -ArgumentList $oldVersion.Major, $oldVersion.Minor, ($oldVersion.Build+1) }

}


function UpdateVersion(){
    [CmdletBinding()]
    Param(

        [Parameter(Position=0, Mandatory=$true)]
        [string] $file,
        [Parameter(Position=1, Mandatory=$true)]
        [ScriptBlock] $updateScript
    )

    $file=Convert-Path $file

    Write-Verbose "Opening file '$file'"

    $xml=[xml](cat $file)

    $productVersionNode=$xml.Project.PropertyGroup.ChildNodes | ? Name -eq ProductVersion

    $oldVersion=[Version]::Parse($productVersionNode.InnerText)
    Write-Verbose "Current version number is '$oldVersion'"

    $newVersion= & $updateScript $oldVersion
    Write-Verbose "New version number is '$newVersion'"

    $productVersionNode.InnerText=$newVersion.ToString()

    Write-Verbose "Saving file '$file'"
    $xml.Save($file)
}

function GetVersion(){
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipeline, Position=0, Mandatory=$true)]
        [string] $file,
		[switch] $AsString
    )
    
    $file=Convert-Path $targetFiles[0]

    Write-Verbose "Opening file '$file'"

    $xml=[xml](cat $file)

    $productVersionNode=$xml.Project.PropertyGroup.ChildNodes | ? Name -eq ProductVersion

    $currentVersion=[Version]::Parse($productVersionNode.InnerText)
	
	if($AsString){
		"Current version number is '$currentVersion'"
	} else {
		$currentVersion
	}
   
}
