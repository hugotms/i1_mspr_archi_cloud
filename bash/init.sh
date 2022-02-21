#!/bin/bash

apt update && apt -y install sudo
groupadd ansible
useradd -m -s /bin/bash -g ansible svcansible
mkdir -p /home/svcansible/.ssh
chmod 700 /home/svcansible
chmod 700 /home/svcansible/.ssh
cat > /home/svcansible/.ssh/authorized_keys << EOF
EOFecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACBod2GgHCeNO+EiXw8S7Ac9tRl1X3OYfZYqHd2VbFD0krvsu3AtCPmIViiHs9YFVUUdNPrYk5aUlpZpf1Azqb8pwDTeeGAfUlnIUZLxr57N0TzYIwfLz7OGQq5q4mldE9fL+4cYb8VGWjK4iEgDSaPFfl6S/AUFvMIm2nO1rreI7BGlg== root@dev.labo.tisamo.loc
EOF
chmod 640 /home/svcansible/.ssh/authorized_keys
chown -R svcansible:ansible /home/svcansible
mkdir /etc/sudoers.d/
cat > /etc/sudoers.d/svcansible << EOF
svcansible  ALL=(ALL) NOPASSWD:ALL
EOF
chmod 644 /etc/sudoers.d/svcansible
