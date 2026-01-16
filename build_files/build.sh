#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux vim 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# 1) Ensure sshd is enabled
systemctl enable sshd

# 2) Open firewall for SSH (if you use firewalld)
if systemctl is-enabled --quiet firewalld 2>/dev/null || systemctl is-active --quiet firewalld 2>/dev/null; then
  firewall-cmd --permanent --add-service=ssh || true
  firewall-cmd --reload || true
fi

install -d -m 0755 /etc/ssh/sshd_config.d

cat > /etc/ssh/sshd_config.d/10-root-login.conf <<'EOF'
PermitRootLogin yes
PasswordAuthentication yes
EOF
