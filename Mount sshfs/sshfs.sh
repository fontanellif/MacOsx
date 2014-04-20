 #!/bin/bash         
 function CheckVolumeDirectory {
 	echo "CheckVolumeDirectory: $1"
 	if [ ! -d "$1" ]; then
 		echo "Create directory!"
 		mkdir $1
 	fi
 }

  #Function: Unmout volume at path
  function UnmountVolume {
  	echo "Unmount SSHFS Volume: $1"
  	diskutil unmountDisk force $1
  }

  #Function: Remove folder at path
  function RemoveFolder {
    echo "Remove SSHFS folder: $1"
    rm -rf $1
  }

  #Function: Mout volume at path
  function MountVolume {
  	echo "MountVolume $1 $2 $3 $4 $5 $6 $7"
  	local sshHostname=$1
  	local sshPort=$2
  	local sshLogin=$3
  	local sshPassword=$4
  	local localPath=$5
  	local remotePath=$6
  	local volumeName=$7

  	local sshURL="$sshLogin@$sshHostname"
  	sshfs -d -p $sshPort $sshURL:$remotePath $localPath -oauto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=$volumeName
  	echo "Mount SSHFS Volume: $localPath"
  }


  if [ "$1" = "-h" ]; then
    echo "Usage: hostname port login password localPath volname"
  else


  # -- SSH parameters
  sshHostname=$1
  sshPort=$2
  sshLogin=$3
  sshPassword=$2

  # -- SSHFS parameters
  remotePath="/"
  localPath=$4
  volumeName=$5
  
  
  # -- Try to unmount
  UnmountVolume $localPath

  # -- Try to remove
  RemoveFolder $localPath
  
  # -- Check local directory path
  CheckVolumeDirectory $localPath
  
  # -- Try to mount
  MountVolume $sshHostname $sshPort $sshLogin $sshPassword $localPath $remotePath $volumeName

  echo "Ok"

  function finish {
  # Your cleanup code here
  direcortyPath="/Users/fontanellif/Desktop/"$volumeName
  UnmountVolume $localPath
  echo "Remove unused directory: $direcortyPath"
  rm -rf $direcortyPath
  }
  trap finish EXIT
fi

