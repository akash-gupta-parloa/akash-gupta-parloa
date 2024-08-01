#!/bin/bash

# Function to generate a random password
generate_password() {
    local password_length=16
    tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c $password_length
}

# Main script
if [ $# -ne 4 ]; then
    echo "Usage: $0 <username> <password> <host> <dbname>"
    exit 1
fi

# Read input parameters
username=$1
password=$2
host=$3
dbname=$4

# Static values for readonly user
readonly_username="kamailio-ro"
readonly_password=$(generate_password)

# Connect to MySQL and create the readonly user
mysql -u $username -p$password -h $host $dbname <<EOF
CREATE USER IF NOT EXISTS '$readonly_username'@'%' IDENTIFIED BY '$readonly_password';
GRANT SELECT ON $dbname.* TO '$readonly_username'@'%';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "Read-only user created successfully."
    echo "User: $readonly_username"
    echo "Password: $readonly_password"
    echo "Connection URL: mysql://$readonly_username:$readonly_password@$host/$dbname"
else
    echo "Failed to create read-only user."
fi

