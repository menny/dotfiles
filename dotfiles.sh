#!/bin/bash

repo_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function link_dotfile_to_actual() {
    local dotfile_repo_path=$1
    local dotfile_target_path=$2
    local backup_folder=$3

    
}

function remove_dotfile() {
    local name=$1
    if [[ -z "${name}" ]] ; then
        echo "missing arguments. dotfiles.sh remove [backup-name]"
        exit 1
    fi

    echo -n "" > ${TMPDIR}/remove_dotfile
    while read -r line
    do
        regex=".+:${name}:(.+)"

        if [[ ${line} =~ ${regex} ]]; then
            local actual_file=${BASH_REMATCH[1]}
            #restoring link
            rm ${actual_file}
            mv ${repo_folder}/${name} ${actual_file}
        else
            echo "${line}" >> ${TMPDIR}/remove_dotfile
        fi
    done < dotfiles.lst
    mv ${TMPDIR}/remove_dotfile dotfiles.lst
}

function add_dotfile() {
    local name=$1
    local dotfile=$2
    local encrypted=${3:-plain}
    if [[ -z "${dotfile}" ]] || [[ -z "${name}" ]] ; then
        echo "missing arguments. dotfiles.sh add/add-enc [full/path/to/.dotfile] [backup-name]"
        exit 1
    fi

    if [[ -f "${dotfile}" ]]; then
        remove_dotfile ${name}
        echo "${encrypted}:${name}:${dotfile}" >> dotfiles.lst
        uniq=($(cat dotfiles.lst | sort -u))
        printf "%s\n" "${uniq[@]}" > dotfiles.lst

        mv ${dotfile} ${repo_folder}/${name}
        ln -s ${repo_folder}/${name} ${dotfile}
    else
        echo "dotfile '${dotfile}' does not exist!"
        exit 1
    fi
}

function add_bin() {
    local required_bin=$1
    command -v ${required_bin} >/dev/null 2>&1 || { echo >&2 "required '${required_bin}' is not installed.  Aborting."; exit 1; }
    echo "${required_bin}" >> required_bins.lst
    uniq=($(cat required_bins.lst | sort -u))
    printf "%s\n" "${uniq[@]}" > required_bins.lst
}

function remove_bin() {
    local name=$1
    if [[ -z "${name}" ]] ; then
        echo "missing arguments. dotfiles.sh remove-bin [required-bin-filename]"
        exit 1
    fi

    while read -r line
    do
        [[ ${line} != ${name} ]] && echo "${line}"
    done < required_bins.lst > ${TMPDIR}/remove_bin
    mv ${TMPDIR}/remove_bin required_bins.lst
}

function verify_bins() {
    while IFS= read -r required_bin
    do
        echo -n "Checking ${required_bin} available.. "
        command -v ${required_bin} >/dev/null 2>&1 || { echo >&2 "required '${required_bin}' is not installed.  Aborting."; exit 1; }
        echo "✓"
    done < required_bins.lst
}

function encrypt_file() {
    local file_to_encrypt=$1
    local encrypted_file=$2
    openssl enc -in ${file_to_encrypt} \
        -aes-256-cbc \
        -pass stdin > ${encrypted_file}
}

function decrypt_file() {
    local file_to_encrypt=$1
    local encrypted_file=$2
    
    openssl enc -in ${encrypted_file} \
        -d -aes-256-cbc \
        -pass stdin > ${file_to_encrypt}
}

function restore_links() {
    echo ""
}

case $1 in
    restore)
        echo "Restoring:"
        verify_bins
        restore_links
        ;;
    add)
        echo -n "Adding backup $2 from dotfile $3: "
        add_dotfile $2 $3
        echo "✓"
        ;;
    add-enc)
        echo "Not supported at the moment"
        exit 1
        ;;
    remove)
        echo -n "Removing dotfile $2: "
        remove_dotfile $2
        echo "✓"
        ;;
    add-bin)
        echo -n "Adding bin $2: "
        add_bin $2
        echo "✓"
        ;;
    remove-bin)
        echo -n "Removing bin $2: "
        remove_bin $2
        echo "✓"
        ;;
    list)
        echo "Required bins:"
        cat required_bins.lst
        echo ""
        echo "Backuped dotfiles:"
        cat dotfiles.lst
        ;;
    *)
        echo "Supported commands:"
        echo "restore - links the dotfiles in this repo to the correct locations."
        echo "add [backup-name] [full/path/to/.dotfile] - adds a dotfile to this repo with the given name."
        echo "*(not supported)* add-enc [backup-name] [full/path/to/.dotfile] - adds a dotfile to this repo with the given name, and encrypts it."
        echo "remove [backup-name] - removes a dotfile from the list of backuped dotfiles."
        echo "add-bin [binary-name] - adds a required bin."
        echo "remove-bin [binary-name] - removes a required bin."
        echo "list - prints out a list of all backup dotfiles and required bins."
    ;;
esac
