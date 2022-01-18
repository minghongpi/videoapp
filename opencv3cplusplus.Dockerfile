FROM ubuntu:18.04
LABEL maintainer="Ming Hong Pi <minghong.pi@gmail.com>"
ENV NUM_CORES 4

# install wget unzip, pkg-config
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y cmake wget unzip pkg-config

# install gcc-9 and g++-9
RUN    apt-get update \
    	&& DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends software-properties-common \
    	&& add-apt-repository ppa:ubuntu-toolchain-r/test \
    	&& DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    		build-essential \
    		gcc-9 \
    		g++-9 \
    		gcc-9-multilib \
    		g++-9-multilib \
    		xutils-dev \
    		patch \
    		git \
    		python3 \
    		python3-pip \
    		libpulse-dev \
    	&& apt clean \
    	&& rm -rf /var/lib/apt/lists/*

RUN    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10 \
    	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 20 \
    	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10 \
    	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 20

# Download and unpack sources
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.16.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.16.zip
RUN unzip opencv.zip
RUN mv opencv-3.4.16 opencv
RUN unzip opencv_contrib.zip
RUN mv opencv_contrib-3.4.16 opencv_contrib
RUN rm -f opencv.zip
RUN rm -f opencv_contrib.zip

# Under opencv, Create build directory and switch into it
RUN mkdir -p /opencv/build

WORKDIR /opencv/build

# Configure
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON  \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
  -D BUILD_PYTHON_SUPPORT=ON \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
	-D WITH_IPP=OFF \
	-D WITH_V4L=ON ..

# Build
RUN cmake --build .

RUN make -j$NUM_CORES

RUN make install

RUN ldconfig
