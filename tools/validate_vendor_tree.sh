#!/bin/sh
# Read-only static validation. Suitable for CI and for maintainers before a tag.
set -eu
repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

for required in \
    dependencies.lock.json \
    THIRD_PARTY_NOTICES.md \
    third_party/eeglab/eeglab.m \
    third_party/eeglab/LICENSE \
    third_party/eeglab/plugins/TESA/eegplugin_tesa.m \
    third_party/eeglab/plugins/EEG-BIDS/eegplugin_eegbids.m \
    third_party/eeglab/plugins/EEG-BIDS/JSONio/LICENSE \
    third_party/eeglab/plugins/BIOSIG/eegplugin_biosig.m \
    third_party/eeglab/plugins/BIOSIG/biosig/t200_FileAccess/sopen.m \
    third_party/fastica/fastica.m \
    third_party/fastica/fpica.m \
    third_party/eeglab/plugins/dipfit/eegplugin_dipfit.m \
    third_party/eeglab/plugins/clean_rawdata/eegplugin_clean_rawdata.m \
    third_party/eeglab/plugins/ICLabel/eegplugin_iclabel.m \
    third_party/eeglab/plugins/firfilt/eegplugin_firfilt.m; do
    [ -e "$repo_root/$required" ] || { echo "Missing: $required" >&2; exit 1; }
done

if find "$repo_root/third_party" -type d -name .git -print -quit | grep -q .; then
    echo 'Nested .git metadata is not allowed in third_party.' >&2
    exit 1
fi
if git -C "$repo_root" submodule status 2>/dev/null | grep -q .; then
    echo 'Git submodules are not allowed in this participant bundle.' >&2
    exit 1
fi
for digest in $(sed -n 's/.*"sha256": "\([0-9a-f]*\)".*/\1/p' "$repo_root/dependencies.lock.json"); do
    [ ${#digest} = 64 ] || { echo "Malformed lock-file checksum: $digest" >&2; exit 1; }
done
if [ -n "${ARCHIVE_DIR:-}" ]; then
    command -v jq >/dev/null || { echo 'jq is required to verify ARCHIVE_DIR.' >&2; exit 1; }
    jq -r '.components[] | [.archive, .sha256] | @tsv' "$repo_root/dependencies.lock.json" | \
    while IFS="$(printf '\t')" read -r archive expected; do
        archive_path="$ARCHIVE_DIR/$archive"
        [ -f "$archive_path" ] || { echo "Missing locked archive: $archive_path" >&2; exit 1; }
        actual=$(shasum -a 256 "$archive_path" | awk '{print $1}')
        [ "$actual" = "$expected" ] || { echo "Checksum mismatch: $archive" >&2; exit 1; }
    done
fi
echo 'Vendor tree static validation passed.'
