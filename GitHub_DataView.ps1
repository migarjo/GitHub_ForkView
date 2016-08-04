#Initial Variables
$UserName='AHAAAAAAA'
$RepoName='PokemonGo-Map'

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Env:GITHUB_OAUTH_TOKEN)))
$Headers=@{Authorization=("Basic {0}" -f $base64AuthInfo)}

Function GetRepo{
	$value = @{}
	$value.Repo=Invoke-RestMethod -headers $Headers -uri "https://api.github.com/repos/$UserName/$RepoName"

	return $value
}

Function DisplayRepo{
	Write-Host "`n`n`nRepository: "$Repo.full_Name"`nDescription: "$Repo.description"`nStars: "$Repo.stargazers_count"`nForks: "$Repo.forks_count
}



Function GetForks{

	$value = @{}

	$value.Parameters = @{
	  sort = 'stargazers'
	}

	$value.ForkArray=Invoke-RestMethod -headers $Headers -uri $Repo.forks_url -Body $value.Parameters

	return $value
}

Function DisplayForkTable{
	Write-Host "`n`nNumber`t`tUser`t`t`tStars`t`tForks`t`t"
	
	$ForkIncr = 1
	for ($i=1;$i -lt 11;$i++) {
		Write-Host "$i`t`t"$ForkArray[$i].owner.login"`t`t"$ForkArray[$i].stargazers_count"`t`t"$ForkArray[$i].forks_count
	}
}


$Repo=$(GetRepo).Repo
DisplayRepo
$ForkArray=$(GetForks).ForkArray
DisplayForkTable

#$StargazerArray=Invoke-RestMethod -headers $Headers -uri "https://api.github.com/repos/$UserName/$RepoName/stargazers"
#$StargazerArray[0]
