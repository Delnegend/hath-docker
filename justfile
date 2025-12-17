_default:
	just --choose

build:
    docker build -t hath --build-arg HATH_VERSION=1.6.4 .

save:
    docker save hath | gzip > hath.tar.gz