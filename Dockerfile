FROM ros:humble

# Use Bash as default shell
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Install dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg \
    wget \
    curl \
    build-essential \
    git \
    cmake \
    python3-colcon-common-extensions \
    ros-humble-rviz2 \
    ros-humble-image-tools \
    ros-humble-tf-transformations \
    unzip \
    udev && \
    rm -rf /var/lib/apt/lists/*

# Clone and build zed-ros2-wrapper (assumes ZED SDK is pre-installed on host)
WORKDIR /workspace
RUN git clone --recursive https://github.com/stereolabs/zed-ros2-wrapper.git src/zed-ros2-wrapper && \
    git clone https://github.com/stereolabs/zed-ros2.git src/zed-ros2 && \
    git clone https://github.com/stereolabs/zed-ros2-examples.git src/zed-ros2-examples

# Build workspace
RUN source /opt/ros/humble/setup.bash && \
    colcon build --symlink-install

# Source setup in shell
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /workspace/install/setup.bash" >> ~/.bashrc

CMD ["bash"]
