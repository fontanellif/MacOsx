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

  #Function: Mout volume at path
  function MountVolume {
  	echo "MountVolume $1 $2 $3 $4 $5 $6 $7"
  	
    echo "Mount SSHFS Volume: $localPath"
    local sshHostname=$1
  	local sshPort=$2
  	local sshLogin=$3
  	local localPath=$4
  	local remotePath=$5
  	local volumeName=$6


  	local sshURL="$sshLogin@$sshHostname"
  	sshfs -d -p $sshPort $sshURL:$remotePath $localPath -oauto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=$volumeName
  	
  }


  # -- SSH parameters
  sshHostname="fontanelli.ntop.org"
  sshPort="22"
  sshLogin="root"

  # -- SSHFS parameters
  remotePath="/"
  localPath="/Users/fontanellif/Desktop/ntop@home"
  volumeName="ntop@home"

  # -- Try to unmount
  UnmountVolume $localPath
  
  # -- Check local directory path
  CheckVolumeDirectory $localPath
  
  # -- Try to mount
  MountVolume $sshHostname $sshPort $sshLogin $localPath $remotePath $volumeName

  echo "Ok"

  function finish {
  # Your cleanup code here
  direcortyPath="/Users/fontanellif/Desktop/"$volumeName
  UnmountVolume $localPath
  echo "Remove unused directory: $direcortyPath"
  rm -rf $direcortyPath
  }
  trap finish EXIT
