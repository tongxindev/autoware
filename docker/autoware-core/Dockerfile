FROM ubuntu:20.04 as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Install apt packages
# hadolint ignore=DL3008
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  git \
  ssh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Copy files
COPY autoware.repos setup-dev-env.sh ansible-galaxy-requirements.yaml /autoware/
COPY ansible/ /autoware/ansible/
WORKDIR /autoware
RUN ls /autoware

## Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

## Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y core \
  && mkdir src \
  # && vcs import src < autoware.repos \ # TODO: Prepare a repos file for Autoware Core
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro galactic \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Create entrypoint
# hadolint ignore=SC1091
RUN echo "source /opt/ros/galactic/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]

FROM devel as prebuilt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Build and change permission for runtime data conversion
# hadolint ignore=SC1091
RUN source /opt/ros/galactic/setup.bash \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && find /autoware/install -type d -exec chmod 777 {} \;

## Create entrypoint
# hadolint ignore=SC1091
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]
