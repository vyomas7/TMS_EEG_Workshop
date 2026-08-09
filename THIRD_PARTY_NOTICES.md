# Third-party source and license report

The exact archive URLs, SHA-256 digests, versions, commits, destinations, and
required entry points are in [`dependencies.lock.json`](dependencies.lock.json).
This document is the human-readable redistribution record for the vendored
sources. No participant downloads dependencies at runtime.

| Dependency | Locked version | License / notice |
| --- | --- | --- |
| EEGLAB | 2026.0.0 (`bcc710a8edd712738e48879b6846958a2be7be1d`) | BSD 2-Clause. Full text is retained at `third_party/eeglab/LICENSE`. Copyright notices are retained in the source. |
| TESA | 1.1.1 (`v1.1.1`) | Source headers identify GPL-2.0-or-later notices and their authors. The upstream release archive does not include a standalone license file; retain all source headers and obtain a maintainer redistribution sign-off before release. |
| EEG-BIDS | 10.5 | The upstream archive includes `JSONio/LICENSE` for its JSON component. The EEG-BIDS repository/release has no repository-level license declaration as retrieved for this lock; public redistribution requires upstream license confirmation. |
| BIOSIG | 3.8.5 | GPL notices and copyright notices are retained in the upstream source files, including `biosig/eeglab/eegplugin_biosig.m`. |
| FastICA | 2.5 | GPL-2.0-or-later. Copyright (C) 1996-2005 Hugo Gavert, Jarmo Hurri, Jaakko Sarela, and Aapo Hyvarinen. The official license statement is at [FastICA About](https://research.ics.aalto.fi/ica/fastica/about.shtml). |
| dipfit | EEGLAB 2026.0.0 pinned submodule | License/copyright notices are retained from the exact upstream commit. |
| clean_rawdata | EEGLAB 2026.0.0 pinned submodule | GPL-3.0; full text is retained at `third_party/eeglab/plugins/clean_rawdata/LICENSE`. |
| ICLabel | EEGLAB 2026.0.0 pinned submodule | License/copyright notices are retained from the exact upstream commit. |
| firfilt | EEGLAB 2026.0.0 pinned submodule | License/copyright notices are retained from the exact upstream commit. |

## Release gate

Do not publish or tag this repository until the missing upstream
redistribution terms for EEG-BIDS, TESA, DIPFIT, ICLabel, and firfilt have been
reviewed and recorded by the workshop maintainer. This report intentionally
does not invent license terms where the upstream archive did not supply them.

