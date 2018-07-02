# Define parameters
$tfsCollectionUrl = New-Object System.URI("http://tfs.prodam:8080/tfs/tpc_prodam"); 

# Load Client Assembly
[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);
[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.VersionControl.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);
[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);
[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Lab.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);
[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Lab.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);  

# Connect to tfs
$tfsCollection = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsCollectionUrl);
$projectService = $tfsCollection.GetService([Microsoft.TeamFoundation.Server.ICommonStructureService]);
$versionControl = $tfsCollection.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer]);
$qtdbranches=0;

cd 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE' 

# Query all the projects and branches

$projects = $projectService.ListAllProjects();
$objallbranch = $versionControl.QueryRootBranchObjects("full")

foreach ($project in $projects)
{
    #Write-Host Finding environments for project $project.Name
    foreach ($branchObject in $objallbranch)
    {
        if ($branchObject.Properties.RootItem.Item.ToUpper().Contains($project.Name.ToUpper())){        

            if($branchObject.Properties.RootItem.IsDeleted){

                #write-host $branchObject
                write-host $branchObject.Properties.RootItem.Item
                .\tf destroy $branchObject.Properties.RootItem.Item /noprompt /startcleanup
                $qtdbranches++
             }
         }
     } 
}
Write-Host "Total de Branches: "  $qtdbranches