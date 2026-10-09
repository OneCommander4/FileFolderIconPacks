# OneCommander File and Folder Icon Packs

This repository contains third-party icon themes reorganized for use as downloadable file and folder icon packs in [OneCommander](https://www.onecommander.com/).

The artwork remains the property of its original authors. OneCommander is not affiliated with or endorsed by the upstream icon-theme projects. Each pack is distributed under its own upstream license; there is no single license covering all artwork in this repository.

## Available packs

| Pack | License family |
| --- | --- |
| Breeze Icons | GNU LGPL 2.1 |
| Catppuccin Icons for VS Code | MIT |
| Colloid Icon Theme | GNU GPL 3 |
| Fluent Icon Theme | GNU GPL 3 |
| Material Icon Theme | MIT |
| Papirus Icon Theme | GNU GPL 3 |
| Qogir Icon Theme | GNU GPL 3 |
| Seti UI | MIT |
| Tela Icon Theme | GNU GPL 3 |
| VSCode Great Icons | MIT |
| vscode-icons | CC BY-SA / mixed upstream icon licensing |
| WhiteSur Icon Theme | GNU GPL 3 |

Visual variants are kept as separate OneCommander style packs. The current collection includes the Catppuccin Frappe, Latte, Macchiato, and Mocha variants; the other included themes currently contain one selected style each.

## Installation

1. Download `OneCommander-FileFolderIconPacks-All.zip` from this repository's Releases page to install every pack, or download an individual `*-OneCommander.zip` file.
2. Extract the archive.
3. Copy its `Icons` directory into OneCommander's `UserResources` directory, merging the `Files` and `Folders` directories when prompted.
4. Select the desired file and folder icon packs in OneCommander settings.

The relevant destination normally has this shape:

```text
OneCommander/
└── UserResources/
    └── Icons/
        ├── Files/
        └── Folders/
```

The precise OneCommander installation or user-data path can vary by installation type.

If you have already opened OneCommander's existing `UserResources\Icons` directory, copy the downloaded `Files` and `Folders` directories into it. Do not create an extra `Icons\Icons` level.

## Package structure

```text
Icons/
├── Files/
│   └── Pack Name/
│       ├── File.svg
│       ├── Types/
│       ├── Names/
│       ├── AUTHORS.txt
│       ├── LICENSE.txt
│       └── SOURCE.txt
└── Folders/
    └── Pack Name/
        ├── FolderIcon.svg
        ├── FolderThumb.svg
        ├── FolderThumbInside.svg
        ├── Names/
        ├── System/
        ├── AUTHORS.txt
        ├── LICENSE.txt
        └── SOURCE.txt
```

- `Types` contains extension-based matches such as `py.svg` or `txt,cfg.svg`.
- File `Names` contains exact full-filename matches such as `.gitignore.svg`.
- Folder `Names` contains exact folder-name matches.
- `System` contains icons for known shell locations such as Documents, Downloads, Desktop, Music, Pictures, Videos, Templates, and Public when supplied by the source theme.
- Empty `Names` or `System` directories mean the upstream pack did not provide applicable matches.

Not every upstream theme supplies every category. Material Icon Theme, for example, does not include generic fallback file or folder artwork in the source snapshot used here; its packages contain `MISSING-FALLBACK.txt`. Packs without folder artwork contain only a Files pack.

## Attribution and licensing

Every file or folder style pack includes:

- `AUTHORS.txt` — upstream authorship and attribution information.
- `LICENSE.txt` — the applicable upstream license text and notices.
- `SOURCE.txt` — upstream project, source location, selected style, and repackaging information.

The repository's `Notices` directory contains each upstream project's `DISTRIBUTION-NOTES.txt` and `PACK-MANIFEST.json`.

Keep these files with every copy and downloadable ZIP. Do not apply a repository-wide license to the included artwork or remove the rights granted by an individual pack's license. Modified artwork must continue to follow its applicable copyleft or attribution requirements.

Brand and product icons may also be subject to trademark rules that are separate from the copyright licenses included here. Inclusion of an icon does not grant permission to imply endorsement by its trademark owner.

## Preparing release ZIPs

The repository includes `tools/Build-Releases.ps1`. It creates:

- `OneCommander-FileFolderIconPacks-All.zip`, containing the complete `Icons` and `Notices` directories.
- One installation-ready ZIP for every named style pack.
- `SHA256SUMS.txt`, containing checksums for all generated ZIPs.

To build them locally from PowerShell:

```powershell
./tools/Build-Releases.ps1
```

The local builder requires 7-Zip. The files are written to the untracked `release` directory.

The `Build release assets` GitHub Actions workflow also runs automatically when a GitHub Release is published and attaches all generated ZIPs and `SHA256SUMS.txt` to that release. A manual workflow run stores the same files as a downloadable workflow artifact.

For GPL-covered artwork, keep the editable SVG source and applicable notices available with the download. If a future release distributes only converted or compiled forms, also provide the matching editable source and any materials required to reproduce those forms.

## Changes from upstream

The upstream artwork has been selected, copied, renamed where necessary for matching, and reorganized into OneCommander's icon-pack directory structure. Refer to each pack's `SOURCE.txt` and `PACK-MANIFEST.json` for details.

## Reporting issues

- Report packaging, filename matching, or OneCommander integration problems in this repository.
- Report artwork-design issues to the corresponding upstream icon-theme project linked from that pack's `SOURCE.txt`.

The licensing notes in this repository are provided as practical compliance guidance and are not legal advice.
