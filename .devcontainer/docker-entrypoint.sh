#!/bin/sh


# add a new non-root for better security
groupadd --gid ${USER_GID} ${USERNAME}
useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}
chmod 0440 /etc/sudoers.d/${USERNAME}


echo "export HTTP_PROXY=${HTTP_PROXY}" >> /home/${USERNAME}/.bashrc
echo "export HTTPS_PROXY=${HTTPS_PROXY}" >> /home/${USERNAME}/.bashrc
echo "export NO_PROXY=${NO_PROXY}" >> /home/${USERNAME}/.bashrc

chown -R ${USERNAME} /home/${USERNAME} 2>&1 > /dev/null
chgrp -R ${USERNAME} /home/${USERNAME} 2>&1 > /dev/null

cd ${WORK_DIR}
sudo -u ${USERNAME} /bin/bash
