#!/bin/bash                                                                   
# Pterodactyl BombSquad Install Script                                        
                                                                              
apt update                                                                    
apt install -y curl tar jq                                                    
                                                                              
cd /mnt/server                                                                
                                                                              
# Determine Architecture                                                      
ARCH=$(uname -m)                                                              
if [ "${ARCH}" == "x86_64" ]; then                                            
    DOWNLOAD_URL="https://github.com/efroemling/ballistica/releases/latest/download/linux_x86_64_server_debug.tar"                                         
elif [ "${ARCH}" == "aarch64" ]; then                                         
    DOWNLOAD_URL="https://github.com/efroemling/ballistica/releases/latest/download/linux_arm64_server_debug.tar"                                          
else                                                                          
    echo "Unsupported architecture: ${ARCH}"                                  
    exit 1                                                                    
fi                                                                            
                                                                              
echo "Downloading BombSquad Server from ${DOWNLOAD_URL}..."                   
curl -L -o server.tar ${DOWNLOAD_URL}                                         
                                                                              
echo "Extracting files..."                                                    
tar -xf server.tar --strip-components=5 "build/prefab/full/linux_${ARCH/aarch 
64/arm64}_server/debug/"                                                      
                                                                              
# Clean up                                                                    
rm server.tar                                                                 
echo "Install complete."
