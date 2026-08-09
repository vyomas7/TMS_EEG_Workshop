# TMS/EEG Workshop

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=vyomas7/TMS_EEG_Workshop&project=Workshop.prj)

Open this repository in MATLAB Online Basic with the button above. When the
committed MATLAB Project opens, it configures this workshop's vendored EEGLAB
and FastICA paths without installing Add-Ons or changing your global MATLAB
configuration.

Run these commands manually, in order:

```matlab
check_environment
eeglab
```

EEGLAB does not launch automatically. If you reopen the project or see a path
warning, run `reset_workshop_environment` and then run
`check_environment` again. Do not run `savepath`, add an EEGLAB Add-On, or use
`genpath` over this repository.

## What is included

This initial environment contains installation validation only—no workshop
lessons or datasets. The repository vendors EEGLAB 2026.0.0, TESA 1.1.1,
EEG-BIDS 10.5, BIOSIG 3.8.5, FastICA 2.5, and EEGLAB's pinned default plugin
sources. Exact archives and SHA-256 checksums are in
[`dependencies.lock.json`](dependencies.lock.json).

## Maintainers

Participants never run the build command. To rebuild vendored sources from
their locked public archives, run:

```sh
sh tools/build_third_party.sh
```

Then run `sh tools/validate_vendor_tree.sh`. The build verifies each archive
checksum and entry point, flattens sources into `third_party`, and rejects
nested Git metadata. Review [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)
before distributing the bundle.

Before the first public release, generate and commit the MATLAB-created
`Workshop.prj` and `resources/project/` files using the steps in
[`MATLAB_PROJECT_REQUIRED.md`](MATLAB_PROJECT_REQUIRED.md). MATLAB's project
XML format is versioned by MathWorks and must not be hand-authored.

Release only after manual MATLAB Online Basic checks on both a clean account
and an account with an existing EEGLAB Add-On: project open/close and reset
cycles, `check_environment`, EEGLAB GUI startup with no duplicate/path
warnings, and registration of TESA, EEG-BIDS, BIOSIG, and FastICA. Tag a fully
tested release as `workshop-2026-v1`; do not add processing/data acceptance
tests until redistributable workshop scripts and datasets are supplied.

