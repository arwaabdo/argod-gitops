#!/bin/bash
alias k=`kubectl`
cd staging
# Loop through each directory in the current directory
for dir in */; do
  # Enter the directory
  cd "$dir"
  
  # Run the kubectl delete and apply commands
  echo "Running commands in $dir"
  # kubectl delete -f deployment.yml
  kubectl apply -f .
  
  # Go back to the original directory
  cd ..
done
