#Make sure Test Attachment cleaner is installed

 

#Config settings:

$CollectionUrlParam = "http://tfs.xxx:8080/tfs/collection/"

$settingsFile = "C:\TMP\TCMPTSettings.xml"

$resultReportFolder = "C:\TMP\TCMPTResults"

$mode = "preview" #preview or delete

 

"<DeletionCriteria><TestRun><AgeInDays OlderThan=""30"" /></TestRun><Attachment />" +

"<LinkedBugs><Exclude state=""Active"" /></LinkedBugs></DeletionCriteria>" | Out-File -FilePath $settingsFile

 

$tcmpt = "C:\Program Files (x86)\Microsoft Team Foundation Server 2015 Power Tools\tcmpt.exe"

 

 

 

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.VersionControl.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Lab.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Lab.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

[Reflection.Assembly]::Load(“Microsoft.TeamFoundation.Build.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”);

 

#connect to TFS, get required services

$tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrlParam)

$bsService = $tfs.GetService("Microsoft.TeamFoundation.Build.Client.IBuildServer")  

$cssService = $tfs.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3")  

 

New-Item -ItemType directory -Path $resultReportFolder -ErrorAction Ignore

 

foreach($project in $cssService.ListProjects())

{

    Write-Host ("Cleanup: " + $project.Name)

    Start-Process ("""" + $tcmpt + """") -Wait -ArgumentList ("attachmentcleanup /collection:""" + $collection + """ /teamProject:""" + $project.Name + """ /settingsFile:" + $settingsFile + " /outputFile:" + $resultReportFolder + "\" + $project.Name + ".txt /mode:" + $mode)

}

 