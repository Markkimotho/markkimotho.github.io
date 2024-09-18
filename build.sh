#!/bin/bash

# Define log file
LOGFILE="build_deploy.log"

# Start logging
echo "Build and deploy started at $(date)" > $LOGFILE

# Add changes to git
echo "Adding changes to git..." | tee -a $LOGFILE
git add . >> $LOGFILE 2>&1

# Check for changes to commit
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to commit." | tee -a $LOGFILE
    echo "Build and deployment completed successfully at $(date)." | tee -a $LOGFILE
    exit 0
fi

# Commit changes with a message
echo "Committing changes..." | tee -a $LOGFILE
git commit -m "Build and deploy at $(date)" >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Commit failed. Please check the log file for details." | tee -a $LOGFILE
    exit 1
fi

# Push changes to the main branch
echo "Pushing changes to the main branch..." | tee -a $LOGFILE
git push -u origin main >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
    echo "Push failed. Please check the log file for details." | tee -a $LOGFILE
    exit 1
fi

# Confirm deployment
echo "Build and deployment completed successfully at $(date)." | tee -a $LOGFILE

# Open the log file
echo "Opening log file..."
xdg-open $LOGFILE 2>/dev/null || open $LOGFILE

