# function AzDevOpsInitCli($token, $url, $project) {
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsRepositories : $url > $project"  
#     Write-Host "==========================================" 
#     az extension add --name azure-devops
#     $token | az devops login --organization $url
#     az devops configure -d organization=$url project=$project
#     az devops configure -l  
#     Write-Host 
# }



function AzDevOpsRepositories($configuration) {  
    Write-Host "Starting: AzDevOpsRepositories" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $organization = $configuration.azureDevops.organization   
    Write-Host "Organization         : " $organization  
    Write-Host "=============================================================================="  
    $organization = $configuration.azureDevops.organization   
    $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
    $Url = "https://dev.azure.com/$organization/$($configuration.projectName)/_apis/git/repositories?api-version=6.0-preview.1"
      
    Write-Host "Performing request on '$Url'." -ForegroundColor Cyan
    
    $response = Invoke-RestMethod `
        -Uri $Url `
        -Method "GET" `
        -ContentType "application/json" `
        -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } 
   
    $repositories = $response.value | Select-Object -Property id, name, defaultBranch 
    $repositories | Format-Table 

    Write-Host "Finishing: AzDevOpsRepositories" -ForegroundColor Green
    Write-Host
    Write-Host 
}

function AzDevOpsProjects($configuration) {  
    Write-Host "Starting: AzDevOpsProjects" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $organization = $configuration.azureDevops.organization   
    Write-Host "Organization         : " $organization  
    Write-Host "=============================================================================="  
    $organization = $configuration.azureDevops.organization   
    $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
    $Url = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0-preview.1"
      
    Write-Host "Performing request on '$Url'." -ForegroundColor Cyan
    
    $response = Invoke-RestMethod `
        -Uri $Url `
        -Method "GET" `
        -ContentType "application/json" `
        -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } 
   
    $projects = $response.value | Select-Object -Property id, name
    $projects | Format-Table 

    Write-Host "Finishing: AzDevOpsProjects" -ForegroundColor Green
    Write-Host
    Write-Host 
}

function AzDevOpsRepositoriesCreate($configuration, $repositoryName) {      
    Write-Host "Starting: AzDevOpsRepositoriesCreate" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $organization = $configuration.azureDevops.organization   
    Write-Host "Organization           : " $organization  
    Write-Host "RepositoryName         : " $repositoryName  
    Write-Host "=============================================================================="  
    $organization = $configuration.azureDevops.organization   
    $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
    $Url = "https://dev.azure.com/$organization/$($configuration.projectName)/_apis/git/repositories?api-version=6.0-preview.1"
    
    Write-Host "Performing request on '$Url'." -ForegroundColor Cyan
          
    $body = @{
        name    = $repositoryName              
        project = @{
            id = "$($configuration.azureDevops.projectId)"
          
        }
        
    }
    
    $json = $body | ConvertTo-Json

    Write-Host "=============================================================================="  
    $json
    Write-Host "=============================================================================="  

    try {
        $response = Invoke-RestMethod `
            -Uri $Url `
            -Method "POST" `
            -ContentType "application/json" `
            -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
            -Body $json 
        $response
    }
    catch {
        Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
        Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $err = $reader.ReadToEnd() | ConvertFrom-Json
        Write-Host -fore blue "Error : " $err.message 
    }

    Write-Host "Finishing: AzDevOpsRepositoriesCreate" -ForegroundColor Green
    Write-Host
    Write-Host    
}



function AzDevOpsRepositoriesCreateBranch($configuration, $repositoryId, $branchName) {     
    Write-Host "Starting: AzDevOpsRepositoriesCreateBranch" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $organization = $configuration.azureDevops.organization   
    Write-Host "Organization           : " $organization  
    Write-Host "RepositoryId           : " $repositoryId   
    Write-Host "BranchName             : " $branchName  
    Write-Host "=============================================================================="  
    $organization = $configuration.azureDevops.organization   
    $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
    $Url = "https://dev.azure.com/$organization/$($configuration.projectName)/_apis/git/repositories/$($repositoryId)/refs?api-version=6.0" 
    
    
 









    # POST https://dev.azure.com/fabrikam/_apis/git/repositories/{repositoryId}/pushes?api-version=7.1-preview.2

    # {
    #   "refUpdates": [
    #     {
    #       "name": "refs/heads/master",
    #       "oldObjectId": "0000000000000000000000000000000000000000"
    #     }
    #   ],
    #   "commits": [
    #     {
    #       "comment": "Initial commit.",
    #       "changes": [
    #         {
    #           "changeType": "add",
    #           "item": {
    #             "path": "/readme.md"
    #           },
    #           "newContent": {
    #             "content": "My first file!",
    #             "contentType": "rawtext"
    #           }
    #         }
    #       ]
    #     }
    #   ]
    # }
    







 
    Write-Host "=============================================================================="  

    $json = ConvertTo-Json @(
        @{
            name        = $branchName        
            oldObjectId = "0000000000000000000000000000000000000000"
            newObjectId = "ffe9cba521f00d7f60e322845072238635edb451"
        
        })
    
  

 
    $json
    Write-Host "=============================================================================="  


    Write-Host "Performing request on '$Url'." -ForegroundColor Cyan
















 





              
 
    try {
        $response = Invoke-RestMethod `
            -Uri $Url `
            -Method "POST" `
            -ContentType "application/json" `
            -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
            -Body $json 
        # Convertir la réponse en format JSON
        $responseJson = $response | ConvertTo-Json -Depth 100

        # Afficher la réponse
        Write-Output $responseJson
    }
    catch {
        Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
        Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $err = $reader.ReadToEnd() | ConvertFrom-Json
        Write-Host -fore blue "Error : " $err.message 
    }
    
    Write-Host "Finishing: AzDevOpsRepositoriesCreateBranch" -ForegroundColor Green
    Write-Host
    Write-Host    
}

 
function AzDevOpsRepositoriesSetDefault($configuration, $repositoryId, $defaultBranch) {     
    Write-Host "Starting: AzDevOpsRepositoriesSetDefault" -ForegroundColor Green
    Write-Host "=============================================================================="    
    $organization = $configuration.azureDevops.organization   
    Write-Host "Organization           : " $organization  
    Write-Host "RepositoryId           : " $repositoryId   
    Write-Host "DefaultBranch          : " $defaultBranch  
    Write-Host "=============================================================================="  
    $organization = $configuration.azureDevops.organization   
    $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
    $Url = "https://dev.azure.com/$organization/$($configuration.projectName)/_apis/git/repositories/$($repositoryId)?api-version=6.0-preview.1"
        
    Write-Host "Performing request on '$Url'." -ForegroundColor Cyan
              
    $body = @{  
        defaultBranch = $defaultBranch            
    }
        
    $json = $body | ConvertTo-Json
    
    Write-Host "=============================================================================="  
    $json
    Write-Host "=============================================================================="  
    
    try {
        $response = Invoke-RestMethod `
            -Uri $Url `
            -Method "PATCH" `
            -ContentType "application/json" `
            -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
            -Body $json 
        $response
    }
    catch {
        Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
        Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $err = $reader.ReadToEnd() | ConvertFrom-Json
        Write-Host -fore blue "Error : " $err.message 
    }
    
    Write-Host "Finishing: AzDevOpsRepositoriesSetDefault" -ForegroundColor Green
    Write-Host
    Write-Host    
}

 
     
      

 


# function AzDevOpsPipelines() {
 
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPipelines : $global:projet"  
#     Write-Host "==========================================" 
#     $organization = $configuration.azureDevops.organization
#     $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
#     $Url = "https://dev.azure.com/$organization/$global:projet/_apis/pipelines?api-version=6.0-preview.1"
   
#     Write-Host "Performing request on '$Url'."
    
#     $response = Invoke-RestMethod `
#         -Uri $Url `
#         -Method "Get" `
#         -ContentType "application/json" `
#         -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
    
#     $pipelines = $response.value | Select-Object -Property id, folder, name, url
#     $pipelines  
# }

  
# function AzDevOpsPipelinesCreate($typologie, $repository) {        
#     $Url = "https://dev.azure.com/$($configuration.azureDevops.organization)/$global:projet/_apis/pipelines?api-version=6.0-preview.1" 
#     $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
 
#     Write-Host "Performing request on '$Url'."    
    
#     $name = $($repository.label)
     
#     $body = @{
#         folder        = $typologie
#         name          = "$typologie-$name"
#         configuration = @{
#             type       = "yaml"
#             path       = "/azure-pipelines/$typologie-$name-pipeline.yml"
#             repository = @{
#                 id   = "$($repository.id)"
#                 name = "$($repository.name)" 
#                 type = "azureReposGit"
#             }
#         }
#     }
    
#     $json = $body | ConvertTo-Json

#     # Write-Host "=====================JSON====================="
#     # $json
#     # Write-Host "=============================================="

#     Write-Host  
#     Write-Host "=====================RESPONSE=====================" 
#     try {
#         $response = Invoke-RestMethod `
#             -Uri $Url `
#             -Method "POST" `
#             -ContentType "application/json" `
#             -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
#             -Body $json 
#         $response
#     }
#     catch {
#         Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
#         Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
#         $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
#         $reader.BaseStream.Position = 0
#         $reader.DiscardBufferedData()
#         $err = $reader.ReadToEnd() | ConvertFrom-Json
#         Write-Host -fore blue "Error : " $err.message 
#     }
#     Write-Host "=================================================="
#     Write-Host
# }







# function AzDevOpsPolicies() { 
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPolicies : $global:projet"  
#     Write-Host "=========================================="     

#     AzDevOpsInitCli $configuration.azureDevops.token $configuration.azureDevops.url $global:projet
 
#     Write-Host "========================================================" 
#     $response = az repos policy list -o table --query "sort_by([].{PolicyId:id,PolicyType:type.displayName, BuildId:settings.buildDefinitionId, BuildName:settings.displayName,Branch:settings.scope[0].refName,RepositoryId:settings.scope[0].repositoryId}, &PolicyType)"
#     $response  
#     Write-Host "========================================================" 
#     Write-Host  
# }

# function AzDevOpsPipelinesAdd($label) {
 
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPipelinesAdd : $global:projet"   
#     Write-Host "==========================================" 
#     Write-Host "Label : $label"  

#     $repository = $global:repositories | Where-Object label -EQ $label      
#     if ($null -eq $repository ) {
#         Write-Warning "Le label '$label' n'a pas permis de trouver le repository."
#         Exit
#     }
#     Write-Host "Repository : $($repository.name)"  
#     Write-Host "==========================================" 
    
#     AzDevOpsPipelinesCreate "build" $repository
#     AzDevOpsPipelinesCreate "deploy" $repository 
# }

# function AzDevOpsPipelinesAddAll() { 
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPipelinesAddAll : $global:projet"  
#     Write-Host "=========================================="     

#     foreach ($repository in $global:repositories) { 
#         AzDevOpsPipelinesAdd $repository.Label 
#         Write-Host 
#     }    
# }
# function AzDevOpsPoliciesAdd($label) {     
#     $branchName = "develop"
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPoliciesAdd : $global:projet"  
#     Write-Host "==========================================" 
#     Write-Host "Label : $label"  
#     Write-Host "Branch : $branchName"  
    
#     $repository = $global:repositories | Where-Object label -EQ $label      
#     if ($null -eq $repository ) {
#         Write-Warning "Le label '$label' n'a pas permis de trouver le repository."
#         Exit
#     }
#     Write-Host "Repository : $($repository.name)"  
#     Write-Host "==========================================" 
 
#     AzDevOpsInitCli $configuration.azureDevops.token $configuration.azureDevops.url $global:projet
 
#     $regex = "build-*"
#     $repositoryId = $($repository.id)

#     $response = az pipelines list --repository $repositoryId | ConvertFrom-Json 
#     $pipeline = $response | Where-Object name -Like $regex | Select-Object -Property id, name
#     if ($null -eq $pipeline ) {
#         Write-Warning "La pipeline pour '$regex' n'a pas permis de trouver le repository $($repository.name)."
#         Exit
#     }
    
#     $buildDefinitionId = $pipeline.id  
#     $displayName = $pipeline.name
#     Write-Host "Pipeline found : "$displayName"("$buildDefinitionId")"     
#     Write-Host "==========================================" 
#     $response = az repos policy list -o json --query "[?settings.scope[?repositoryId=='$repositoryId']].{PolicyId:id,PolicyType:type.displayName, BuildId:settings.buildDefinitionId, BuildName:settings.displayName,Branch:settings.scope[0].refName}" | ConvertFrom-Json
#     # $response 
#     $filtered = $response | Where-Object { $_.PolicyType -eq 'Build' -and $_.BuildName -eq $displayName } #| Select-Object -Property  id,   @{Name="settings"; Expression={ $_.settings | Select-Object buildDefinitionId, displayName }}
#     # $filtered
#     $count = ([array] $filtered).Count
#     Write-Host "Policies on repository $($repository.name) : $count "    
#     Write-Host "==========================================" 
    
#     if ($count -eq 0  ) {
#         Write-Host 'Adding policy...'
#         $policy = az repos policy build create --blocking true --branch $branchName --build-definition-id $BuildDefinitionId --display-name $displayName --enabled true --manual-queue-only false --queue-on-source-update-only false --repository-id $repositoryId --valid-duration 0 | ConvertFrom-Json
#         if ($null -eq $policy ) {
#             Write-Warning "Creating policy failed."
#             Exit
#         }
#         Write-Host 'Creating policy on date : ' $policy.createdDate
#     }
#     else {
#         $p = $filtered | Select-Object -First 1
#         Write-Host "Policy : "$p.PolicyId" (BuildId : "$p.BuildId")" 
#     }
#     Write-Host "====================================================================================" 
#     Write-Host 
# }
# function AzDevOpsPoliciesAddAll() {
 
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPoliciesAddAll : $global:projet"  
#     Write-Host "==========================================" 

#     foreach ($repository in $global:repositories) { 
#         AzDevOpsPoliciesAdd $repository.Label 
#         Write-Host 
#     }    
# }












# function AzDevOpsPullRequestsCreate($repositoryName, $sourceRefName , $title) {    
#     $path = Get-Location
#     Set-Location $repositoryName  
#     $repositoryPath = Get-Location
#     Write-Host "=========================================="
#     Write-Host "Creating a PR '$title' for $repositoryName from branch '$sourceRefName'"
#     Write-Host "=========================================="
 

#     $organization = $configuration.azureDevops.organization


 

#     $Url = "https://dev.azure.com/$organization/$global:projet/_apis/git/repositories/$repositoryName/pullrequests?api-version=6.0"


  
#     $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))
 
#     Write-Host "Performing request on '$Url'."    
    
   

     
#     $body = @{
#         sourceRefName = $sourceRefName
#         targetRefName = "refs/heads/develop"
#         title         = "$title"
         
#     }
    
#     $json = $body | ConvertTo-Json

#     # Write-Host "=====================JSON====================="
#     #    $json
#     # Write-Host "=============================================="

#     Write-Host  
#     Write-Host "=====================RESPONSE=====================" 
#     try {
#         $response = Invoke-RestMethod `
#             -Uri $Url `
#             -Method "POST" `
#             -ContentType "application/json" `
#             -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
#             -Body $json 
#         $response
#     }
#     catch {
#         Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
#         Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
#         $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
#         $reader.BaseStream.Position = 0
#         $reader.DiscardBufferedData()
#         $err = $reader.ReadToEnd() | ConvertFrom-Json
#         Write-Host -fore blue "Error : " $err.message 
#     }
#     Write-Host "=================================================="
#     Write-Host












#     Set-Location $path  
# } 


# function AzDevOpsPullRequestsCreateProjet( $sourceRefName, $title ) {     
     
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPullRequestsCreateProjet : "$global:projet
#     Write-Host "Title : "$title
#     Write-Host "==========================================" 
    
#     foreach ($repo in $global:repositories) {        
#         AzDevOpsPullRequestsCreate $repo.name $sourceRefName $title
#     }   
# }

# function AzDevOpsPipelinesTest() {     
     
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPipelinesTest : "$global:projet
#     Write-Host "==========================================" 
    
#     $organization = $configuration.azureDevops.organization
#     $pipelineId = 82 

#     $Url = "https://dev.azure.com/$organization/$global:projet/_apis/pipelines/$pipelineId/runs?api-version=6.0-preview.1"


 
#     Write-Host "=========================================="
#     Write-Host "Creating a run"
#     Write-Host "=========================================="







#     $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))

#     Write-Host "Performing request on '$Url'."    
 
#     $json = '{"stagesToSkip":[],"resources":{"repositories":{"self":{"refName":"refs/heads/develop"}}},"templateParameters":{"version":"0.0.X","ignoreDockerBuild":"False","environments":"- Test\r\n- Staging\r\n- Demo","imageName":"bons-production"},"variables":{}}'
  

#     # $json = $body | ConvertTo-Json

#     Write-Host "=====================JSON====================="
#     $json
#     Write-Host "=============================================="

#     Write-Host  
#     Write-Host "=====================RESPONSE=====================" 
#     try {
#         $response = Invoke-RestMethod `
#             -Uri $Url `
#             -Method "POST" `
#             -ContentType "application/json" `
#             -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
#             -Body $json 
#         $response
#     }
#     catch {
#         Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
#         Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
#         $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
#         $reader.BaseStream.Position = 0
#         $reader.DiscardBufferedData()
#         $err = $reader.ReadToEnd() | ConvertFrom-Json
#         Write-Host -fore blue "Error : " $err.message 
#     }
#     Write-Host "=================================================="
#     Write-Host







 
# }




#  function AzDevOpsTestsRunDelete($runId) {     
     
#     Write-Host "=========================================="
#     Write-Host "AzDevOpsPipelinesTest : "$global:projet
#     Write-Host "AzDevOpsPipelinesTest : "$runId
#     Write-Host "==========================================" 
    
#      $organization = $configuration.azureDevops.organization
   

#      $Url = "https://dev.azure.com/$organization/$global:projet/_apis/test/runs/${runId}?api-version=6.0"


 
#       Write-Host "=========================================="
#       Write-Host "Delete run $runId"
#       Write-Host "=========================================="







#     $tokenBase64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "anything", $configuration.azureDevops.token)))

#     Write-Host "Performing request on '$Url'."    
 
 
 
#      Write-Host  
#      Write-Host "=====================RESPONSE=====================" 
#      try {
#          $response = Invoke-RestMethod `
#              -Uri $Url `
#              -Method "DELETE" `
#              -ContentType "application/json" `
#              -Headers @{Authorization = ("Basic {0}" -f $tokenBase64) } `
             
#          $response
#      }
#      catch {
#          Write-Host -fore blue "Code : " $_.Exception.Response.StatusCode.value__ 
#          Write-Host -fore blue "Description : " $_.Exception.Response.StatusDescription
#          $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
#          $reader.BaseStream.Position = 0
#          $reader.DiscardBufferedData()
#          $err = $reader.ReadToEnd() | ConvertFrom-Json
#          Write-Host -fore blue "Error : " $err.message 
#      }
#      Write-Host "=================================================="
#      Write-Host







 
# }
 