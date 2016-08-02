#Initial Variables
$username='AHAAAAAAA'
$repo='PokemonGo-Map'

$stargazers=Invoke-RestMethod -uri "https://api.github.com/repos/$username/$repo/stargazers"
$stargazers[0]