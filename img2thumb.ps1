#img2thumb.ps1 powershell script
#Joey Collard
#creates a smaller image at same aspectratio based on $destWidth
#skips over existing thumb named files
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [single]$width=100
    )
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
$destWidth = $width; # use cmdline arg to specify taret width
Foreach ($extension in '*.png','*.jpg') {
  Get-ChildItem $extension | Foreach-Object {
    $pic = $_; # File object
    #Write-Host $pic.Name;
    $srcPath = $(resolve-path $pic).ToString();
    if ($pic.Name -inotlike "*thumb*")
    {      
      $full = [System.Drawing.Image]::FromFile($srcPath); # Image object
      $sourceWidth = $full.Width;
      $sourceHeight = $full.Height;
      $sourceRatio = $sourceHeight/$sourceWidth;
      $scaledHeight = $destWidth * $sourceRatio;      
      $thumb = $full.GetThumbnailImage($destWidth, $scaledHeight, $null, [intptr]::Zero);
      
      $destPath = $srcPath +".thumb"+ $pic.Extension; 
      Write-Host "From " $srcPath " " $sourceWidth"/"$sourceHeight " ("$sourceRatio")";
      Write-Host "To " $destPath " " $destWidth"/"$scaledHeight;
      $thumb.Save($destPath);
      $full.Dispose();
      $thumb.Dispose();
    } 
  }
}