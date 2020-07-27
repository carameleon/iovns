#!/bin/bash

DIR_HOME=/dev/shm/blackhole

if [ $# -lt 1 ]; then
  >&2 cat <<USAGE
Usage:
  $0 'multisig //id' <'another multisig //id'> ...

Description:
  This script creates a throw-away account for each input, ie the mnemonic is
  not displayed.  The pubkey of the account is displayed and can be used to
  create a unique multisig account given common signatories among multiple
  multisig accounts.  eg, Antoine, Benjamin, and Karim are signatories for IOV
  SAS, the reward fund, escrows converted to multisigs, etc.  In order for
  each of those multisig accounts to be unique, an additional signatory must
  be included in each multisig.  Using the pubkey of throw-away accounts
  generated by this script achievs the goal of uniqueness.

Variables:
  DIR_HOME=$DIR_HOME
USAGE
  exit 1
fi

mkdir -pv $DIR_HOME

for i in "$@"; do
   iovnscli keys add "$i" --home $DIR_HOME --keyring-backend file --dry-run | egrep '(name)|(pubkey):' 2> /dev/null
   echo
done

rm -rfv $DIR_HOME