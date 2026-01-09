# syntax=docker/dockerfile:1

# if provided it will mark it as debug build
ARG build_type=Release
# system to start with the build with
# currently will break for other images
ARG base_image=ubuntu:latest

#-------------------------------RUNNER--------------------------------
# Create a new stage for the runtime environment
FROM ${base_image} AS runner

# Environment settings
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Renew the args
ARG build_type
LABEL BOMBSQUAD_BUILD_TYPE=${build_type}

# Install runtime dependencies
RUN useradd -m -s /bin/bash container && \
    apt-get update && \
    apt-get install -y software-properties-common &&\    
    add-apt-repository ppa:deadsnakes/ppa &&\    
    apt-get update && \    
    apt-get install -y python3.13-dev && \                                                         
    apt-get clean && \                                                        
    python3.13 -c "import uuid; print(uuid.uuid4())" > /etc/machine-id  \
    mkdir -p /home/me

# Switch to container user
USER container
ENV USER=container HOME=/home/container

# Copy the compiled application from the builder stage
COPY bs_server/* /home/me

# Set the working directory
WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

# Set permissions
USER root
RUN chmod +x /entrypoint.sh && chown -R container:container /home/me
USER container

# Expose the necessary port
EXPOSE 43210/udp

# Set the default command to run the application
CMD [ "/entrypoint.sh" ]