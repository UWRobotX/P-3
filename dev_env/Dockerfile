#----------------------------------------------#
# UW RobotX Development Environment Dockerfile #
#----------------------------------------------#

FROM ubuntu:16.04

# Install core utilities
RUN apt update
RUN apt install -y wget

# Configure ROS Kinetic Kane (LTS) environment
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main"'\
'> /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt update
RUN apt install -y ros-kinetic-desktop
RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"
RUN apt install -y python-rosinstall \
                   python-rosinstall-generator \
                   python-wstool \
                   build-essential

# Ensure OpenCV and any relevant packages are installed. We'll do this through
# the ROS package to prevent any library loading conflicts.
RUN apt install -y ros-kinetic-opencv3 \
                   ros-kinetic-cv-camera \
                   ros-kinetic-opencv-apps

# Configure Gazebo 8 simulation framework
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable'\
          '`lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt install -y gazebo8 \
                   libgazebo8-dev
