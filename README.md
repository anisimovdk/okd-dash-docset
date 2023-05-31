# OKD Dash DocSet Builder

Tool for building OKD Rest API Reference documents for Kapeli Dash

## Build in docker

### Build image

```bash
# build with local arch (Intel or Apple Silicon or other)
docker build -t okd-dash-docset-builder -f Dockerfile .

# build image for Intel on Apple Silicon
docker build --platform linux/amd64 -t okd-dash-docset-builder -f Dockerfile .
```

### Run build in docker

```bash
# prepare docset artifact dir
mkdir -p release

# build from main branch
docker run --rm -v $PWD/release:/app/release okd-dash-docset-builder

# build specified version
docker run --rm -v $PWD/release:/app/release okd-dash-docset-builder 4.13

# build specified version and tag it latest
docker run --rm -v $PWD/release:/app/release okd-dash-docset-builder 4.13 latest

# build multiple versions at once
for version in 4.4 4.5 4.6 4.7 4.8 4.9 4.10 4.11 4.12 4.13; do docker run --rm -v $PWD/release:/app/release okd-dash-docset-builder $version&; done
```

## Build on OSX

### Install dependencies

```bash
brew install dashing
brew install asciidoctor
```

### Build localy

```bash
# build from main branch
./build.sh

# build specified version
./build.sh 4.13

# build specified version and tag it latest
./build.sh 4.13 latest
```

## Currently supported/tested doc versions

* 4.4
* 4.5
* 4.6
* 4.7
* 4.8
* 4.9
* 4.10
* 4.11
* 4.12
* 4.13
