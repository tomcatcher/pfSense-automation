#!/usr/bin/bash

# Backup script, simple, monolithic
# This script creates a snapshot of VM determined by the third positional parameter.

# Initialization of variables
# Set loglevel to maximum verbosity
# loglevel="err"
# loglevel="warning"
# loglevel="info"
# loglevel="debug"

# Source functions.sh
source functions.sh

# Log info (info), using the new function
log backup info "Backup script started"

log backup info "Setting and verifying variables"

# Checking dependencies

checkdep date
checkdep pwgen
checkdep pvesh
checkdep awk
checkdep grep
checkdep cat
checkdep tr
checkdep fold
checkdep head
checkdep tail
checkdep shuf
checkdep df

# Log info (info)
log backup info "Dependencies checked"

# Call checkparams function
checkparams "$@"

# Log info (info)
log backup info "Parameters checked"

# Set variables

# nodename="$1"
# vmtype="$2"
# vmid="$3"
format="text"
snapshot_name=$($vmid)_$($datecmd +%Y%m%d_%H%M%S)_$(echo "SNAP0-`for i in a b c d e f; do $catcmd /dev/urandom | $trcmd -dc 'a-z' | $foldcmd -w 2 | $headcmd -n 1;$shufcmd -i 100000-999999 -n 1; done`" | $trcmd -d "\n")
snapshotcreationparams="--quiet --snapname $snapshot_name"
snapshotstatuscheckparams="--output-format $format --human-readable 1 --noborder 1 --noheader 1 --source all --limit 1 --vmid $vmid"
snapshotcreationapipath="/nodes/$nodename/$vmtype/$vmid/snapshot"
snapshotstatusapipath="/nodes/$nodename/tasks"
snapshotcreationmethod="create"
snapshotstatusmethod="get"
mountpoint="/mnt/pve/elements"

# Log info (info)
log backup info "Variables set"

# Log debug info (debug)
if "$loglevel" == "debug"
then
    # Log debug info (debug)
    log backup debug "$($dfcmd -m $mountpoint | $awkcmd '{ print $4 }' | $tailcmd -n 1) MiB free on $mountpoint before backup started. END OF DEBUG MESSAGE"
fi

# Create the snapshot
dobackup $pveshcmd $snapshotcreationmethod $snapshotcreationapipath $snapshotcreationparams

# Check the status of the last snapshot creation operation
checkbackup $pveshcmd $snapshotstatusmethod $snapshotstatusapipath $snapshotstatuscheckparams

# Log debug info (debug)
if "$loglevel" == "debug"
then
    # Log debug info (debug)
    log backup debug "$($dfcmd -m $mountpoint | $awkcmd '{ print $4 }' | $tailcmd -n 1) MiB free on $mountpoint after backup ended. END OF DEBUG MESSAGE"
fi

# Log info (info) - end of backup script
log backup info "Backup script has finished operation"

exit 0