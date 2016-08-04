#Initial Variables
$UserName='AHAAAAAAA'
$RepoName='PokemonGo-Map'

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Env:GITHUB_OAUTH_TOKEN)))
$Headers=@{Authorization=("Basic {0}" -f $base64AuthInfo)}


$Repo=Invoke-RestMethod -headers $Headers -uri "https://api.github.com/repos/$UserName/$RepoName"
$Repo





Function GetForks{

	$value = @{}

	$value.Parameters = @{
	  sort = 'stargazers'
	}

	$value.ForkArray=Invoke-RestMethod -headers $Headers -uri $Repo.forks_url -Body $value.Parameters


	
	return $value
}

$ForkArray=$(GetForks).ForkArray

foreach ($Fork in $ForkArray) {
	Write-Host "User " $Fork.owner.login"'s fork has "$Fork.stargazers_count" stars and "$Fork.forks_count" forks."
}

#$StargazerArray=Invoke-RestMethod -headers $Headers -uri "https://api.github.com/repos/$UserName/$RepoName/stargazers"
#$StargazerArray[0]
