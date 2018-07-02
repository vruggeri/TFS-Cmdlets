#Config settings:
$CollectionUrlParam = "http://tfs.xxx:8080/tfs/collection/"

#connect to TFS, get required services
$tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrlParam)
$cssService = $tfs.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3")   

cd 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE'
$count = 0

#list all projects
foreach($proj in $cssService.ListProjects())
{ 
    .\TFSSecurity.exe /g- ("["+ $proj.Name +"]\Project Administrators") RDOMAIN\UserORGroup /collection:$CollectionUrlParam 
    $count++
} 

Write-Host "Total de projetos: " $count