#Initial Variables
$UserName='AHAAAAAAA'
$RepoName='PokemonGo-Map'


$Repo=Invoke-RestMethod -uri "https://api.github.com/repos/$UserName/$RepoName"
$Repo

Function GetForks{

	$value = @{}

	$value.Parameters = @{
	  sort = 'stargazers'
	}

	$value.ForkArray=Invoke-RestMethod -uri $Repo.forks_url -Body $value.Parameters
	
	return $value
}

$ForkArray=$(GetForks).ForkArray

foreach ($Fork in $ForkArray) {
	Write-Host "User " $Fork.owner.login"'s fork has "$Fork.stargazers_count" stars and "$Fork.forks_count" forks."
}





#$StargazerArray=Invoke-RestMethod -uri "https://api.github.com/repos/$UserName/$RepoName/stargazers"
#$StargazerArray[0]
