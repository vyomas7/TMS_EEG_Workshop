#!/bin/sh
# Maintainers only. Rebuilds third_party from dependencies.lock.json's locked
# archives. It is intentionally not used by setup_workshop or participants.
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
archive_dir=${ARCHIVE_DIR:-"$repo_root/build/archives"}
stage=$(mktemp -d "${TMPDIR:-/tmp}/tms-eeg-workshop.XXXXXX")
trap 'rm -rf "$stage"' EXIT HUP INT TERM
mkdir -p "$archive_dir" "$stage/downloads" "$stage/third_party/eeglab/plugins"

download() {
    name=$1 expected=$2 url=$3
    target="$archive_dir/$name"
    if [ ! -f "$target" ]; then
        curl --fail --location --retry 3 --output "$target" "$url"
    fi
    actual=$(shasum -a 256 "$target" | awk '{print $1}')
    [ "$actual" = "$expected" ] || {
        echo "Checksum mismatch for $name" >&2
        echo "Expected: $expected" >&2
        echo "Actual:   $actual" >&2
        exit 1
    }
}

extract_one_root() {
    archive=$1 destination=$2
    unpack="$stage/unpack-$(basename "$archive" .zip)"
    mkdir -p "$unpack" "$destination"
    unzip -q "$archive" -d "$unpack"
    roots=$(find "$unpack" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    [ "$roots" = 1 ] || { echo "Expected one root directory in $archive" >&2; exit 1; }
    source=$(find "$unpack" -mindepth 1 -maxdepth 1 -type d)
    cp -R "$source"/. "$destination"/
}

download eeglab-2026.0.0.zip 2f08c23c8f1cfe7734974e54b8a5dcd2e1c8891738415bdcbc5d94fd0d660769 https://codeload.github.com/sccn/eeglab/zip/refs/tags/2026.0.0
download TESA-1.1.1.zip 0c442809ca4d8bfba258f25da26ce545a9ed65b09d0fb5fc8e273a7ca089cc85 https://github.com/nigelrogasch/TESA/releases/download/v1.1.1/TESA1.1.1.zip
download EEG-BIDS-10.5.zip 5ac10d152f9fe3945f2321c4bfdadb682ed9e591bb26d285015263277c4c5d85 https://sccn.ucsd.edu/eeglab/plugins/EEG-BIDS10.5.zip
download BIOSIG-3.8.5.zip 44a5d43a22f5f2f2945e5c0aa720ea7a85e90a2a3f0f6200f15f176d571cdbda https://sccn.ucsd.edu/eeglab/plugins/Biosig3.8.5.zip
download FastICA-2.5.zip e8fa9e065cbed9e35309505fd77ef45f44db68d729c31cfb372bacbc41a3353c https://research.ics.aalto.fi/ica/fastica/code/FastICA_2.5.zip
download dipfit-b0b660e7.zip 9db25b97017b36441a5b936c336807fc1fce368b6ba60a7b91c0bd1a76e35603 https://codeload.github.com/sccn/dipfit/zip/b0b660e7efca0a9b68a4afb4e1749042e327b90c
download clean_rawdata-d4b143f2.zip 7aa9c39bdcc5bdd0fa0a82ac80fdff214c7ee61b022956728b145d44b3e5fb11 https://codeload.github.com/sccn/clean_rawdata/zip/d4b143f2a7719cf12d46c9b3e15aa827edb05614
download ICLabel-644578bd.zip a57e3016256338aa69f6db66c9f58c913e9ed7bce301167d2ca0afaa40b7612d https://codeload.github.com/sccn/ICLabel/zip/644578bd34c77262ab5563ae4af5fb7269ccc81c
download firfilt-ff8227f8.zip face26f8439111f6543fc970ab693ca68084d5b4bce94da324278899542f9d35 https://codeload.github.com/sccn/firfilt/zip/ff8227f85816364e5cd26d9d22665091be4ead17

extract_one_root "$archive_dir/eeglab-2026.0.0.zip" "$stage/third_party/eeglab"
extract_one_root "$archive_dir/TESA-1.1.1.zip" "$stage/third_party/eeglab/plugins/TESA"
extract_one_root "$archive_dir/EEG-BIDS-10.5.zip" "$stage/third_party/eeglab/plugins/EEG-BIDS"
extract_one_root "$archive_dir/BIOSIG-3.8.5.zip" "$stage/third_party/eeglab/plugins/BIOSIG"
extract_one_root "$archive_dir/FastICA-2.5.zip" "$stage/third_party/fastica"
extract_one_root "$archive_dir/dipfit-b0b660e7.zip" "$stage/third_party/eeglab/plugins/dipfit"
extract_one_root "$archive_dir/clean_rawdata-d4b143f2.zip" "$stage/third_party/eeglab/plugins/clean_rawdata"
extract_one_root "$archive_dir/ICLabel-644578bd.zip" "$stage/third_party/eeglab/plugins/ICLabel"
extract_one_root "$archive_dir/firfilt-ff8227f8.zip" "$stage/third_party/eeglab/plugins/firfilt"

# The official BIOSIG archive stores its EEGLAB entry points one level below
# the plugin directory. EEGLAB discovers only direct eegplugin_*.m files, so
# retain the original sources in their archive layout and expose copies at the
# standard plugin root. Its historic entry point looks for ../t200; this
# symlink preserves that upstream-relative lookup without adding BIOSIG paths
# during project startup.
cp "$stage/third_party/eeglab/plugins/BIOSIG/biosig/eeglab/eegplugin_biosig.m" "$stage/third_party/eeglab/plugins/BIOSIG/eegplugin_biosig.m"
cp "$stage/third_party/eeglab/plugins/BIOSIG/biosig/eeglab/pop_biosig.m" "$stage/third_party/eeglab/plugins/BIOSIG/pop_biosig.m"
ln -s BIOSIG/biosig/t200_FileAccess "$stage/third_party/eeglab/plugins/t200"

# Archives may contain old source-control bookkeeping. It is not source code
# and must never become nested repository metadata in the public bundle.
find "$stage/third_party" -type d \( -name .git -o -name .hg -o -name CVS \) -prune -exec rm -rf {} +
if find "$stage/third_party" -type d -name .git -print -quit | grep -q .; then
    echo 'Nested .git metadata found after extraction.' >&2
    exit 1
fi

for required in \
    "$stage/third_party/eeglab/eeglab.m" \
    "$stage/third_party/eeglab/plugins/TESA/eegplugin_tesa.m" \
    "$stage/third_party/eeglab/plugins/EEG-BIDS/eegplugin_eegbids.m" \
    "$stage/third_party/eeglab/plugins/BIOSIG/eegplugin_biosig.m" \
    "$stage/third_party/fastica/fastica.m"; do
    [ -e "$required" ] || { echo "Missing required entry point: $required" >&2; exit 1; }
done

rm -rf "$repo_root/third_party"
mv "$stage/third_party" "$repo_root/third_party"
sh "$repo_root/tools/validate_vendor_tree.sh"
echo 'third_party rebuilt from locked archives.'
