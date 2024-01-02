# Functions for baskup script

function log() {
    # Setting variables
    local unitname="$1"
    local verbosity="$2"
    local infomessage="$3"
    # Convert verbosity to uppercase
    local logtaglabel=${verbosity^^}
    # Construct the logmessage
    local logmessage="$logtaglabel\t$(echo \"$infomessage\")"
    # Log the message
    echo "$logmessage" | systemd-cat -t "$unitname" -p "verbosity"
    return $?
}

function checkdep() {
    # Setting and checking variables
    case "$1" in
        "date")
            local package="coreutils"
            ;;
        "pwgen")
            local package="pwgen"
            ;;
        "pvesh")
            local package="pvesh"
            ;;
        "awk")
            local package="gawk"
            ;;
        "grep")
            local package="grep"
            ;;
        "cat")
            local package="coreutils"
            ;;
        "tr")
            local package="coreutils"
            ;;
        fold)
            local package="coreutils"
            ;;
        "head")
            local package="coreutils"
            ;;
        "tail")
            local package="coreutils"
            ;;
        "shuf")
            local package="coreutils"
            ;;
        "df")
            local package="coreutils"
            ;;
        *)
            exit 1
            ;;
    esac
    # Check if the command is installed
    local cmd=$(command -v "$1")
    if [[ "#?" -ne 0 ]]
    then
        # Log warning (warning) and try to install coreutils
        log backup warning "$cmd command not found, trying to install it"
        apt-get install "$package"
        if [[ "#?" -ne 0 ]]
        then
            # Always log this err (err) and exit 1
            log backup err "$cmd command not found and could not be installed"
            exit 1
        fi
    fi
    return 0
}

function checkparams() {
    # Setting variables
    nodename="$1"
    vmtype="$2"
    vmid="$3"
    # Check if all positional parameters are set, if not, ask during runtime
    if [[ $# -ne 3 ]]
    then
        # Log warning (warning) and print usage message
        echo "Usage:"
        echo $(echo "$0" | $sedcmd 's/\// /g' | $awkcmd '{ print $NF }')$(echo "<nodename> <vmtype> <vmid>")
        log backup warning "Incorrect number of positional parameters"
        read -p "Enter nodename: " nodename
        read -p "  Enter vmtype: " vmtype
        read -p "    Enter vmid: " vmid
        return 0
    fi
    return 0
}

function dobackup() {
    $1 $2 $3 $4
    if [[ "#?" -ne 0 ]]
    then
        # Log err (err) and exit 1
        log backup err "Snapshot creation failed"
        exit 1
    fi
}

function checkbackup() {
    # Setting variables
    local snapshotstatus=""
    # Check the status of the last snapshot creation operation                                   
    while [ "$snapshotstatus" != "OK" ]
    do
        sleep 1
        snapshotstatus=$($1 $2 $3 $4 | $awkcmd '{ print $10 }')
        if [[ "$snapshotstatus" == "ERROR" ]]
        then
            # Log err (err) and exit 1
            log backup err "Snapshot creation failed"
            exit 1
        fi
    done
    if [[ "$snapshotstatus" == "OK" ]]
    then
        # Log info (info)
        log backup info "Snapshot creation successful"
    fi
    return 0
}