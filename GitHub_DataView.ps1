#Initial Variables
$baseReposURL='https://api.github.com/repos'
$fullName='AHAAAAAAA/PokemonGo-Map'

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
	Write-Host "`n`n`nRepository: "$repo.full_Name"`nDescription: "$repo.description"`nStars: "$repo.stargazers_count"`nForks: "$repo.forks_count
	if ($parentUserRepo.ContainsKey($repo.url)){
	Write-Host "Forked from: "$parentUserRepo.get_item("repo.url")}
}

Function GetForks{

	$value = @{}

	$value.Parameters = @{
	  sort = 'stargazers'
	}

	$value.ForkArray=Invoke-RestMethod -headers $headers -uri $repo.forks_url -Body $value.Parameters

	return $value
}

Function DisplayForkTable{
	Write-Host "`n`nNumber`t`tUser`t`t`tStars`t`tForks`t`t"

	for ($i=1;$i -lt 11;$i++) {
		Write-Host "$i`t`t"$forkArray[$i-1].owner.login"`t`t"$forkArray[$i-1].stargazers_count"`t`t"$forkArray[$i-1].forks_count
	}
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

$repoURL = "" + $baseReposURL + "/" + $fullName

$repo=$(GetRepo).Repo
$forkArray=$(GetForks).ForkArray
$forkArray

$action = "";
$newRepoIndex = -1; 
while ($action -ne "x"){
	DisplayRepo
	DisplayForkTable
	
	$action = Read-Host -Prompt "`nWhat action would you like to take? `nPossible Actions: `n`t(G)o to fork`n`te(X)it"
	if ($action -eq "g"){
		
		$newRepoIndex = Read-Host -Prompt "Please select 0 to see Parent Repository or the index of the fork you would like to see"
		if ($newRepoIndex -eq 0) {
			$repoURL = $(GetParentUserRepoURL).URL
			$repo=$(GetRepo).Repo
			$forkArray=$(GetForks).ForkArray
		}	
		else {
			$parentUserRepo.Set_Item($forkArray[$newRepoIndex].url,$repo.url)
			$repoURL = $forkArray[$newRepoIndex].url
			$repo=$(GetRepo).Repo
			$forkArray=$(GetForks).ForkArray
		}
	}
}
