mkdir __temp__
curl https://raw.githubusercontent.com/DevecorSoft/DockerDesktopAlternative/main/name.txt -so ./__temp__/name.txt
cat ./__temp__/name.txt
rm -rf ./__temp__

brew install --cask multipass
sleep 15
echo "-------- Start to install docker via multipass... --------"
echo ""

echo "-------- Stage 1: Initializing ubuntu... --------"
multipass launch --disk 32G --mem 4G --cpus 2 --name primary
echo "-------- Ubuntu initialized successfully. --------"
echo ""

echo "-------- Stage 2: Installing docker engine... --------"
multipass exec -v primary -- bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg'
multipass exec -v primary -- bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
multipass exec -v primary -- sudo apt-get update
multipass exec -v primary -- sudo apt-get install -y docker-ce docker-ce-cli containerd.io
if [[ $(multipass exec -v primary -- docker --version) == "Docker version"* ]]
then
echo "-------- docker engine installed successfully. --------"
echo ""
else
exit 1
fi

echo "-------- Stage 3: Configuring docker... --------"
echo '{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' | multipass exec -v primary -- sudo tee /etc/docker/daemon.json
multipass exec -v primary -- sudo mkdir -p /etc/systemd/system/docker.service.d
multipass exec -v primary -- sudo bash -c "echo '[Service]' > /etc/systemd/system/docker.service.d/override.conf"
multipass exec -v primary -- sudo bash -c "echo 'ExecStart=' >> /etc/systemd/system/docker.service.d/override.conf"
multipass exec -v primary -- sudo bash -c "echo 'ExecStart=/usr/bin/dockerd' >> /etc/systemd/system/docker.service.d/override.conf"
multipass exec -v primary -- sudo bash -c "echo '' >> /etc/systemd/system/docker.service.d/override.conf"
multipass exec -v primary -- sudo bash -c "cat /etc/systemd/system/docker.service.d/override.conf"
multipass exec -v primary -- sudo systemctl daemon-reload
multipass exec -v primary -- sudo systemctl restart docker.service
echo $'\nexport DOCKER_HOST="tcp://192.168.64.2:2375"' >> ~/.zshrc
source ~/.zshrc
echo "-------- Docker configuring finished. --------"
echo ""

brew install docker docker-compose

if [[ $(docker ps) == "CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES" ]]
then
echo ""
echo "-------- Enjoy!!! --------"
else
exit 1
fi
