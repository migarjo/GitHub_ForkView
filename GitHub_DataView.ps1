#Initial Variables
$UserName='AHAAAAAAA'
$RepoName='PokemonGo-Map'

$Repo=Invoke-RestMethod -uri "https://api.github.com/repos/$UserName/$RepoName"
#$Repo

$Parameters = @{
  sort = 'stargazers'
}

$ForkArray=Invoke-RestMethod -uri $Repo.forks_url -Body $Parameters
#$ForkArray



 foreach ($Fork in $ForkArray) {
   "User " + $Fork.owner.login + "'s fork has " + $Fork.stargazers_count + " stars and " + $Fork.forks_count+ " forks."
 }

#$StargazerArray=Invoke-RestMethod -uri "https://api.github.com/repos/$UserName/$RepoName/stargazers"
#$StargazerArray[0]
