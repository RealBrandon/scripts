#!/usr/bin/bash

SSH_CONFIG_PATH="$HOME/.ssh/config"

while ! [[ -f "$SSH_CONFIG_PATH" ]]
do
  echo "No SSH configuration file can be found at $SSH_CONFIG_PATH ."
  echo 'Please enter the path to the SSH configuration file:'
  read SSH_CONFIG_PATH
done
echo "SSH configuration file found at $SSH_CONFIG_PATH ."

while true
do
  echo
  echo 'How do you authenticate for all the servers to run commands on?' 
  echo '1: password'
  echo '2: private key with a passphrase'
  echo '3: private key without a passphrase'
  echo '4: other authentication methods'
  read -p 'Please enter your answer in number [1/2/3/4]: ' ANSWER
  echo

  if [[ $ANSWER -eq 1 ]]
  then
    echo 'To make the script work, please ensure all passwords used are the same.'
    echo 'Please enter the password:'
    read -s PASSWORD

    # Set up environment variables to force ssh/ssh-add to use the askpass script.
    SSH_ASKPASS_REQUIRE='force'
    SSH_ASKPASS="$HOME/.echo_pass.sh"
    export SSH_ASKPASS_REQUIRE SSH_ASKPASS
    # Create the askpass script to be used.
    echo '#!/usr/bin/bash' > $SSH_ASKPASS
    echo 'echo $PASS' >> $SSH_ASKPASS
    chmod a+x $SSH_ASKPASS
    break
  elif [[ $ANSWER -eq 2 ]]
  then
    IDENTITIES=$(grep '.*IdentityFile.*' $SSH_CONFIG_PATH | cut -d ' ' -f 4)
    # Field number 4 may not work on others' SSH configuration file.
    ssh-add $IDENTITIES
    # echo $IDENTITIES
    # ssh-add -l
    break
  elif [[ $ANSWER -eq 3 ]]
  then
    break
  elif [[ $ANSWER -eq 4 ]]
  then
    echo 'Sorry, this script currently does not support other authentication methods.'
    exit 1
  else
    echo 'Invalid input. Please try again.'
  fi
done

SERVERS=$(grep '^Host.*' $SSH_CONFIG_PATH | cut -d ' ' -f 2)
# echo $SERVERS

echo
echo 'Please the enter the command to be run on all servers:'
read COMMAND
echo

for TARGET_SERVER in $SERVERS
do
  echo "Executing the command on $TARGET_SERVER via SSH..."
  ssh -F $SSH_CONFIG_PATH $TARGET_SERVER $COMMAND
  echo
done

# Clean up askpass script.
[[ $ANSWER -eq 1 ]] && rm -f $SSH_ASKPASS
