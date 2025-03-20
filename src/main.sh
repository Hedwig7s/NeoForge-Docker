#!/usr/bin/env bash

#* All Arguments Supported
#NEOFORGE_VERSION="20.4.190"        # NeoForge version
#MC_EULA="true"                     # Minecraft's Eula
#MC_RAM_XMS="1536M"                 # Preallocated RAM
#MC_RAM_XMX="2048M"                 # Max RAM
#MC_PRE_JAR_ARGS=""                 # ARG's before the JAR
#MC_POST_JAR_ARGS=""                # ARG's after the JAR
#MC_URL_ZIP_SERVER_FIILES=""        # Zip for all of the server files. Gets merged with the current Server Folder
#FORCE_INSTALL=""                   # Force the installation of the NeoForge jar

MCDIR="/home/server"
INSTALLER_JAR="neoforge-$NEOFORGE_VERSION-installer.jar"
MCTEMP="/server_tmp"
JVM_ARGS="-Xms$MC_RAM_XMS -Xmx$MC_RAM_XMX --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 $MC_PRE_JAR_ARGS"

cd $MCDIR

echo "###############################################"
echo "#   NeoForge - `date`   #"
echo "###############################################"
echo 
echo "Initializing..."

function GetFile {
    [ -n "$1" ] && curl -s -C - -o "$2" "$1" || return 1
    [ $? -eq 0 ] && echo "Downloaded $1" && return 0 ||\
                    echo "Could not get $1" && return 1
}

# Check if we need to install or reinstall NeoForge
if [[ ! -e "$MCDIR/run.sh" || "$INSTALLER_JAR" != "$(find . -name "neoforge-*-installer.jar" -printf "%f\n" 2>/dev/null | sort -V | tail -n 1)" || -n $FORCE_INSTALL ]]; then
    echo "Downloading and installing NeoForge..."
    
    # Remove old installers
    rm -f "$MCDIR"/neoforge-*-installer.jar
    
    # Download new installer
    GetFile "https://maven.neoforged.net/releases/net/neoforged/neoforge/$NEOFORGE_VERSION/$INSTALLER_JAR" "$MCDIR/$INSTALLER_JAR"
    
    # Install server
    java -jar "$MCDIR/$INSTALLER_JAR" --installServer
    
    if [[ $? -ne 0 ]]; then
        echo "NeoForge installation failed!"
        exit 1
    fi
fi

# Create JVM arguments file
echo "$JVM_ARGS" > "$MCDIR/user_jvm_args.txt"

# Getting Server files from user
GetFile "$MC_URL_ZIP_SERVER_FIILES" "$MCDIR/ZIP_SERVER_FILES"
[ $? -eq 0 ] && unar "$MCDIR/ZIP_SERVER_FILES" -f

# Accepting EULA
[ "$MC_EULA" == "true" ] && echo "Setting EULA to true" && printf "eula=true" > $MCDIR/eula.txt

echo "Initialization finished!"
echo
echo "#################### Info #####################"
echo " NEOFORGE_VERSION: $NEOFORGE_VERSION"
echo " MC_EULA: $MC_EULA"
echo " MC_RAM_XMS: $MC_RAM_XMS"
echo " MC_RAM_XMX: $MC_RAM_XMX"
echo " MC_PRE_JAR_ARGS: $MC_PRE_JAR_ARGS"
echo " MC_POST_JAR_ARGS: $MC_POST_JAR_ARGS"
echo " MC_URL_ZIP_SERVER_FIILES: $MC_URL_ZIP_SERVER_FIILES"
echo "###############################################"
echo
echo "Starting Server..."
echo

# Making run.sh executable
chmod +x "$MCDIR/run.sh"

# Starting the server
exec "$MCDIR/run.sh" $MC_POST_JAR_ARGS --nogui