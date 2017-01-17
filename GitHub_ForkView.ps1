Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$FullName
)

#Initial Variables
$baseReposURL='https://api.github.com/repos'
#$fullName='twbs/bootstrap'

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Env:GITHUB_OAUTH_TOKEN)))
$headers=@{Authorization=("Basic {0}" -f $base64AuthInfo)}
$parentUserRepo=@{}


#Functions
Function GetRepo{
	$value = @{}
	$value.Repo=Invoke-RestMethod -headers $Headers -uri $repoURL
					

	return $value
}

Function DisplayRepo{
	cls
	Write-Host "`n`n`nRepository: "$repo.full_Name"`nDescription: "$repo.description"`nWatchers: "$repo.watchers_count"`nForks: "$repo.forks_count
	if ($parentUserRepo.ContainsKey($repo.url)){
	Write-Host "Forked from: "$(GetParentUserRepoURL).URL"`n`n"}
	
}

Function GetForks{

	$value = @{}

	$value.Parameters = @{
	  sort = 'stargazers'
	}

	$value.fullForkArray=Invoke-RestMethod -headers $headers -uri $repo.forks_url -body $value.Parameters

	$value.forkArray = @()
	$value.forkCt = 0
	Write-Host $value.fullForkArray[$value.forkCt].watchers_count;
	while ($value.fullForkArray[$value.forkCt].watchers_count -gt 0 -And $value.forkCt -lt 10){
		$value.forkArray += $value.fullForkArray[$value.forkCt]
		$value.forkCt++
	}
	
	return $value
}

Function DisplayForkTable{
	#Write-Host "`n`nNumber`t`tUser`t`t`tWatchers`t`tForks`t`t"
	
	$forkTable = @()
	$forkCt = 1;
	foreach($fork in $forkArray){
		$forkTableRecord = @{}
		$forkTableRecord.Index = $forkCt;
		$forkTableRecord.Login = $fork.owner.login
		$forkTableRecord.Watchers = $fork.watchers_count
		$forkTableRecord.Forks = $fork.forks_count
		
		$forkTable += $forkTableRecord
		$forkCt++
	}
	
	$forkTable.ForEach({[PSCustomObject]$_}) | Format-Table Index, Login, Watchers, Forks -AutoSize
	
	#for ($i=1;$i -lt 11;$i++) {
	#	Write-Host "$i`t`t"$forkArray[$i-1].owner.login"`t`t"$forkArray[$i-1].watchers_count"`t`t"$forkArray[$i-1].forks_count
	#}
}

Function GetParentUserRepoURL{
	$value = @{}
	if ($parentUserRepo.containsKey($repo.url)){
		$value.URL = $parentUserRepo.get_item($repo.url)
	}
	else{
		Write-Host "Error: Cannot find a repository from which this has been forked"
		$value.URL = $repo.url
	}
	
	return $value
}

$repoURL = "" + $baseReposURL + "/" + $FullName

$repo=$(GetRepo).Repo
$forkArray=$(GetForks).forkArray

$action = "";
$newRepoIndex = -1; 
while ($action -ne "x"){
	DisplayRepo
	DisplayForkTable
	
	$action = Read-Host -Prompt "`nWhat action would you like to take? `nPossible Actions: `n`t(G)o to fork`n`t(O)pen Repository`n`te(X)it"
	if ($action -eq "g"){
		
		$newRepoIndex = Read-Host -Prompt "Please select 0 to see Parent Repository or the index of the fork you would like to see"
		if ($newRepoIndex -eq 0) {
			$repoURL = $(GetParentUserRepoURL).URL
			$repo=$(GetRepo).Repo
			$forkArray=$(GetForks).ForkArray
		}	
		else {
			$parentUserRepo.Set_Item($forkArray[$newRepoIndex-1].url,$repo.url)
			$repoURL = $forkArray[$newRepoIndex-1].url
			$repo=$(GetRepo).Repo
			$forkArray=$(GetForks).ForkArray
		}	
	}
	elseif ($action -eq "o"){
		Invoke-Expression "cmd.exe /C start $($repo.html_url)"
		$action = 'x'
	}
}
