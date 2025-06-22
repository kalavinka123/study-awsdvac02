## Install Ansible
sudo apt update
sudo apt install --yes software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install --yes ansible

## Create Ansible Playbook
mkdir -p ${ANSIBLE_DIR}/investories/group_vars

cat > ${ANSIBLE_DIR}/investories/hosts.ini << 'EOF'
[targets]
target_server01 ansible_host=192.168.97.31 ansible_user=vagrant
EOF

cat > ${ANSIBLE_DIR}/site.yml << 'EOF'
- name: Install AWS CLI on Ubuntu
  hosts: target_server01
  become: true
  vars_files:
    - aws_sso_config.yaml
  tasks:
    - name: Update apt package index
      apt:
        update_cache: yes

    - name: Install required packages for AWS CLI
      apt:
        name:
          - curl
          - unzip
        state: present

    - name: Download AWS CLI installer
      get_url:
        url: "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
        dest: "/tmp/awscliv2.zip"

    - name: Unzip AWS CLI installer
      unarchive:
        src: "/tmp/awscliv2.zip"
        dest: "/tmp"
        remote_src: yes

    - name: Run AWS CLI installer
      command: "/tmp/aws/install"

    - name: Verify AWS CLI installation
      command: "aws --version"
      register: aws_cli_version

    - name: Display AWS CLI version
      debug:
        msg: "{{ aws_cli_version.stdout }}"

    - name: Create .aws directory
      file:
        path: "{{ ansible_env.HOME }}/.aws"
        state: directory
        mode: '0700'
        owner: vagrant
        group: vagrant

    - name: Create AWS config file for SSO
      copy:
        dest: "{{ ansible_env.HOME }}/.aws/config" ## TODO  Path should be vagrant user's home.
        content: |
          [profile {{ aws_sso_profile }}]
          sso_start_url = {{ sso_start_url }}
          sso_region = {{ sso_region }}
          sso_account_id = {{ sso_account_id }}
          sso_role_name = {{ sso_role_name }}
          region = {{ region }}
          output = {{ output }}
        mode: '0600'      
        owner: vagrant
        group: vagrant
EOF

## Creating a Shell script for generating SSH key and copying it to a target node.
cat > ${VAGRANT_HOME}/ssh-setup.sh << 'EOF'
#!/bin/bash

KEY_PATH="$HOME/.ssh/id_rsa"

# Prompt for remote host details
read -p "Enter remote user (e.g., ubuntu): " REMOTE_USER
read -p "Enter remote host (e.g., 192.168.1.100): " REMOTE_HOST

# Check if key already exists
if [ -f "$KEY_PATH" ]; then
  echo "SSH key already exists at $KEY_PATH"
else
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
  echo "SSH key generated at $KEY_PATH"
fi

# Copy the key to the remote server
echo "Copying SSH public key to $REMOTE_USER@$REMOTE_HOST..."
ssh-copy-id -i "$KEY_PATH.pub" "$REMOTE_USER@$REMOTE_HOST"

# Test SSH connection
echo "Testing SSH connection..."
ssh "$REMOTE_USER@$REMOTE_HOST" "echo '✅ SSH key authentication succeeded!'"
EOF

sudo chmod 755 ${VAGRANT_HOME}/ssh-setup.sh