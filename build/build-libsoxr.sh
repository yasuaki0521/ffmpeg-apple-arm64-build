#!/bin/sh
# $1 = script directory
# $2 = working directory
# $3 = tool directory
# $4 = CPUs
# $5 = libsoxr version

# load functions
. $1/functions.sh

SOFTWARE=libsoxr

make_directories() {

  # start in working directory
  cd "$2"
  checkStatus $? "change directory failed"
  mkdir ${SOFTWARE}
  checkStatus $? "create directory failed"
  cd ${SOFTWARE}
  checkStatus $? "change directory failed"

}

download_code () {

  cd "$2/${SOFTWARE}"
  checkStatus $? "change directory failed"
  #mkdir ${SOFTWARE}
  checkStatus $? "create directory failed"

  # download source
  #curl -O -L https://sourceforge.net/projects/soxr/files/soxr-$5-Source.tar.xz

  #checkStatus $? "download of ${SOFTWARE} failed"

  # unpack
  #tar -zxf "soxr-$5-Source.tar.xz" -C "${SOFTWARE}" --strip-components 1
  #checkStatus $? "unpack libsoxr failed"

  # cp instead download and unpack
  cp -rf /Users/home/Music/FFmpeg/compile/sox/soxr-0.1.3-Source "$2/${SOFTWARE}"
  # rename
  mv soxr-0.1.3-Source ${SOFTWARE}


  #cd "soxr-$5-Source/"
  cd "${SOFTWARE}"
  checkStatus $? "change directory failed"

}

configure_build () {

  #cd "$2/${SOFTWARE}/soxr-$5-Source/"
  cd "$2/${SOFTWARE}/"
  checkStatus $? "change directory failed"
  mkdir build_${SOFTWARE}
  checkStatus $? "creating build  directory failed"
  cd "build_${SOFTWARE}/" 
  checkStatus $? "change directory failed"

  # prepare build
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$3 -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -Wno-dev ../$SOFTWARE

  checkStatus $? "configuration of ${SOFTWARE} failed"

}

make_clean() {

  #cd "$2/${SOFTWARE}/soxr-$5-Source/"
  cd "$2/${SOFTWARE}/build_${SOFTWARE}/"
  checkStatus $? "change directory failed"
  make clean
  checkStatus $? "make clean for $SOFTWARE failed"

}

make_compile () {

  #cd "$2/${SOFTWARE}/soxr-$5-Source/"
  cd "$2/${SOFTWARE}/build_${SOFTWARE}/"
  checkStatus $? "change directory failed"

  # build
  make -j $4
  checkStatus $? "build of ${SOFTWARE} failed"

  # install
  make install
  checkStatus $? "installation of ${SOFTWARE} failed"

}

build_main () {

  if [[ -d "$2/${SOFTWARE}" && "${ACTION}" == "skip" ]]
  then
      return 0
  elif [[ -d "$2/${SOFTWARE}" && -z "${ACTION}" ]]
  then
      echo "${SOFTWARE} build directory already exists but no action set. Exiting script"
      exit 0
  fi


  if [[ ! -d "$2/${SOFTWARE}" ]]
  then
    make_directories $@
    download_code $@
    configure_build $@
  fi

  make_clean $@
  make_compile $@

}

build_main $@
