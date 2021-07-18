#!/bin/bash
 
ocv_ver="4.5.2"
rdir=`pwd`
ffmpeg_version="4.4"

#Install Dependencies 
sudo apt update
sudo apt -y dist-upgrade
sudo apt install -y sudo nano htop mediainfo build-essential autoconf automake cmake libtool git \
checkinstall nasm yasm libass-dev htop libfreetype6-dev libsdl2-dev p11-kit \
libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev  \
frei0r-plugins-dev gnutls-dev ladspa-sdk libcaca-dev libcdio-paranoia-dev \
libcodec2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libgme-dev \
libgsm1-dev libjack-dev libmodplug-dev libmp3lame-dev libopencore-amrnb-dev \
libopencore-amrwb-dev libopenjp2-7-dev libopenmpt-dev libopus-dev \
libpulse-dev librsvg2-dev librubberband-dev librtmp-dev libshine-dev \
libsmbclient-dev libsnappy-dev libsoxr-dev libspeex-dev libssh-dev \
libtesseract-dev libtheora-dev libtwolame-dev libv4l-dev libvo-amrwbenc-dev \
libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev libx265-dev \
libxvidcore-dev libxml2-dev libzmq3-dev libzvbi-dev liblilv-dev libdrm-dev \
libopenal-dev opencl-dev libjack-dev libbluray-dev libfdk-aac-dev openssl libssl-dev \
libunistring-dev libbluray-dev libcurl4-openssl-dev unzip libgphoto2-dev libtesseract-dev tesseract-ocr libvo-amrwbenc-dev libvpx-dev libwebp-dev libx265-dev libzmq3-dev libx264-dev frei0r-plugins-dev gcc gobjc pkg-config libpthread-stubs0-dev libpciaccess-dev make patch yasm g++ autoconf cmake automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev texi2html zlib1g-dev libx264-dev libmp3lame-dev libfaac-dev librtmp-dev libvo-aacenc-dev libx264-dev libgtk-3-dev python-numpy python3-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libtiff5-dev   libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libv4l-dev libtbb-dev qtbase5-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip libopus-dev libsoxr-dev libleptonica-dev libspeex-dev libjpeg-dev libpng-dev libtiff-dev


#Download OpenCV, OpenCV_contrib and FFmpeg
wget https://github.com/opencv/opencv/archive/$ocv_ver.zip -O opencv-$ocv_ver.zip
wget https://github.com/opencv/opencv_contrib/archive/$ocv_ver.zip -O opencv_contrib-$ocv_ver.zip
wget https://ffmpeg.org/releases/ffmpeg-$ffmpeg_version.tar.xz

#Build and Install FFmpeg

tar -xf ffmpeg-$ffmpeg_version.tar.xz
cd ffmpeg-$ffmpeg_version

#librtmp is disabled intentionally to enable built-in FFmpeg RTMP protocol which is more reliable
./configure \
--disable-static \
--enable-decoder='mjpeg,png,jpg' \
--enable-demuxer=image2 \
--enable-frei0r \
--enable-gmp \
--enable-gnutls \
--enable-gpl \
--enable-iconv \
--enable-indev=alsa \
--enable-ladspa \
--enable-libass \
--enable-libbluray \
--enable-libcaca \
--enable-libcdio \
--enable-libcodec2 \
--enable-libdrm \
--enable-libfdk-aac \
--enable-libfontconfig \
--enable-libfreetype \
--enable-libfribidi \
--enable-libgme \
--enable-libgsm \
--enable-libjack \
--enable-libmodplug \
--enable-libmp3lame \
--enable-libopencore-amrnb \
--enable-libopencore-amrwb \
--enable-libopenjpeg \
--enable-libopenmpt \
--enable-libopus \
--enable-libpulse \
--enable-librsvg \
--disable-librtmp \
--enable-librubberband \
--enable-libshine \
--enable-libsnappy \
--enable-libsoxr \
--enable-libspeex \
--enable-libssh \
--enable-libtheora \
--enable-libtwolame \
--enable-libv4l2 \
--enable-libvo-amrwbenc \
--enable-libvorbis \
--enable-libvpx \
--enable-libwebp \
--enable-libx264 \
--enable-libx265 \
--enable-libxml2 \
--enable-libxvid \
--enable-libzmq \
--enable-libzvbi \
--enable-lv2 \
--enable-nonfree \
--enable-openal \
--enable-opencl \
--enable-opengl \
--enable-outdev=alsa \
--enable-protocol=file \
--enable-shared \
--enable-small \
--enable-static \
--enable-vaapi \
--enable-vdpau \
--enable-version3 \
--enable-zlib \
--extra-libs=-lm \
--extra-libs=-lpthread

make -j16
make alltools
make install

cd "$rdir"

#Build and Install OpenCV
unzip opencv-$ocv_ver.zip 
unzip opencv_contrib-$ocv_ver.zip

cd opencv-$ocv_ver/
mkdir build;cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON \
    -D WITH_CUDA=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D OPENCV_GENERATE_PKGCONFIG=YES \
    -D BUILD_opencv_apps=OFF \
    -D OPENCV_EXTRA_MODULES_PATH="$rdir"/opencv_contrib-$ocv_ver/modules .. \
    -D BUILD_EXAMPLES=OFF ..

sudo make -j16 install
cd "$rdir"
