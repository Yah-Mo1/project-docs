#!/bin/bash

# Navigating into the app folder
cd repo/app

# Export DB_HOST with the correct IP address
export DB_HOST=mongodb://10.0.3.4:27017/posts

# Start the app
pm2 start app.js