# code for File Intergrity Montoring

write-Host ""
write-Host "what would you like to do ?"
write-Host ""
write-Host "A) collect new Baseline"
write-Host "B) begin files Monitoring"
write-Host ""

$response = Read-Host -Prompt " 'A' or 'B' "
write-Host ""  #Spaces

Function Calculate-File-Hash($filehash) {
    $filehash = Get-FileHash -Path $filehash -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists () {
$baselineExists = Test-Path -Path C:\Users\scott\Desktop\FIM\baseline.txt

    if ($baselineExists) {
    #delete It
    Remove-Item -Path C:\Users\scott\Desktop\FIM\baseline.txt
    }
}

if ($response -eq "A".ToUpper()) 
    {
    #Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists
     #calculate the hash from the target files and store in baseline.txt

     #collect all files in the target folder
     $files = Get-ChildItem -Path C:\Users\scott\Desktop\FIM\Files
     
     #for each file calculate the hash, and write to baseline.txt
     foreach ($f in $files) {
         $tito = Calculate-File-Hash $f.Fullname
         "$($tito.Path) |$($tito.Hash)" | Out-File -FilePath C:\Users\scott\Desktop\FIM\baseline.txt -Append
        }
    }


elseif ($response -eq "B".ToUpper()) {

      $fileHashDict = @{}

    #load filehash from baseline.txt and store them in dictionary
    $filePathesAndHashes = Get-Content -Path C:\Users\scott\Desktop\FIM\baseline.txt

    foreach ($f in $filePathesAndHashes){
       $fileHashDict.add($f.Split(" ")[0],$f.Split(" ")[1])
        }
    }
     
    #Continuosly  Monitoring files with saved basline
    While($true) {
    Start-Sleep -seconds 1
    
     $files = Get-ChildItem -Path C:\Users\scott\Desktop\FIM\Files
     
     #for each file calculate the hash, and write to baseline.txt

     foreach ($f in $files) {
             $tito = Calculate-File-Hash $f.Fullname

            if ($fileHashDict[$tito.Path] -eq $null) {
            # New file created
            Write-Host "$($tito.Path) has been created" -ForegroundColor Red
            }
    
         else {
                      
            #Notify if a file has been changed
            if ($fileHashDict[$tito.Path] -eq $tito.Hash) {
                 #the file remains the same
       }

       
      
        }

        foreach ($key in $fileHashDict.Keys) {
        $baselineFilesStillExists = Test-Path -Path $key
        if (-not $baselineFilesStillExists) {
        #one baseline file deleted
        write-Host "$($Key) has been deleted" -ForegroundColor Green

             }
        }
    }
 }              
            

