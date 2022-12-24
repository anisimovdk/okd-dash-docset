#!/bin/bash

docs_repo="https://github.com/openshift/openshift-docs"
icon_url="https://assets.openshift.net/content/subdomain/favicon32x32.png"
workdir=$( cd "$(dirname "$0")" ; pwd -P )

echo "Checking dependencies... "
for dep in git asciidoctor dashing curl tar; do
  [[ $(which $dep 2>/dev/null) ]] || { echo "${dep} needs to be installed."; deps=1; }
done

[[ $deps -ne 1 ]] || { echo "Install the above and rerun this script."; exit 1; }

ver=$1

latest=$2

[[ -z "$ver" ]] && ver=main

[[ "$ver" == 'main' ]] && branch="main" || branch="enterprise-${ver}"

build_dir="${workdir}/build/${ver}"

git clone --depth 1 --branch "${branch}" --single-branch "${docs_repo}" "${build_dir}"

cd "${build_dir}" || { echo "Buildir '${build_dir}' not found."; exit 1; }

echo "Start generating HTML from AsciiDocs:"
for doc in rest_api/index.adoc rest_api/*_apis/*.adoc; do
  echo "Processing '${doc}'"
  asciidoctor --verbose -D "html_$(dirname ${doc})" "${doc}";
done

echo "Generating 'dashing.json'."
echo "{ \"name\": \"OKD\", \"package\": \"okd\", \"index\": \"index.html\", \"selectors\": { \"h1\": \"Type\", \"h3\": \"Field\" }, \"icon32x32\": \"favicon32x32.png\", \"allowJS\": false, \"ExternalURL\": \"https://docs.okd.io/${ver}/rest_api/\" }" > html_rest_api/dashing.json

cd html_rest_api || { echo "HTML dir 'html_rest_api' not found."; exit 1; }

echo "Downloading docset ICON from '${icon_url}'."
curl -o favicon32x32.png -s "${icon_url}" || { echo "Icon download failed."; exit 1; }

echo "Generating docset"
dashing build || { echo "Generating docset failed."; exit 1; }

echo "Releasing docset"
tar --exclude='.DS_Store' -cvzf okd.tgz okd.docset || { echo "Creating docset archive failed."; exit 1; }

[[ "$latest" == 'latest' ]] && release_dir="${workdir}/release" || release_dir="${workdir}/release/versions/okd/${ver}"

mkdir -p "${release_dir}"

mv okd.tgz "${release_dir}/"

echo "All done. Docset location '${release_dir}/okd.tgz'"
