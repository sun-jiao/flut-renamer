#!/usr/bin/env python3
"""Generate package-manager manifests from the actual release assets."""
import argparse
import hashlib
import json
import re
from pathlib import Path
from urllib.parse import quote


def sha256(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def generate(assets, repository, tag):
    if not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository):
        raise ValueError('Expected an owner/repository GitHub repository')
    if not re.fullmatch(r'v\d+\.\d+\.\d+', tag):
        raise ValueError('Release tags must use vX.Y.Z')
    version = tag[1:]
    homepage = f'https://github.com/{repository}'
    base = f'{homepage}/releases/download/{quote(tag, safe="")}'
    # Read all required inputs before writing any manifests.
    dmg_hash = sha256(assets / 'flut-renamer.dmg')
    exe_hash = sha256(assets / 'flut-renamer.exe')
    (assets / 'flut-renamer.rb').write_text(f'''cask "flut-renamer" do
  version "{version}"
  sha256 "{dmg_hash}"

  url "{base}/flut-renamer.dmg"
  name "Flut Renamer"
  desc "Batch rename files and directories"
  homepage "{homepage}"

  depends_on macos: ">= :catalina"
  app "Flut Renamer.app"
end
''')
    scoop = {
        'version': version,
        'description': 'Batch rename files and directories',
        'homepage': homepage,
        'license': 'GPL-3.0-only',
        'architecture': {'64bit': {
            'url': f'{base}/flut-renamer.exe', 'hash': exe_hash,
        }},
        'bin': 'flut-renamer.exe',
        'shortcuts': [['flut-renamer.exe', 'Flut Renamer']],
    }
    (assets / 'flut-renamer.json').write_text(json.dumps(scoop, indent=2) + '\n')
    winget = {
        '$schema': 'https://aka.ms/winget-manifest.singleton.1.6.0.schema.json',
        'PackageIdentifier': 'SunJiao.FlutRenamer',
        'PackageVersion': version,
        'PackageLocale': 'en-US',
        'Publisher': 'Sun Jiao',
        'PackageName': 'Flut Renamer',
        'License': 'GPL-3.0-only',
        'LicenseUrl': f'{homepage}/blob/{tag}/LICENSE',
        'ShortDescription': 'Batch rename files and directories',
        'PackageUrl': homepage,
        'InstallerType': 'portable',
        'Scope': 'user',
        'Commands': ['flut-renamer'],
        'Installers': [{
            'Architecture': 'x64',
            'InstallerUrl': f'{base}/flut-renamer.exe',
            'InstallerSha256': exe_hash.upper(),
        }],
        'ManifestType': 'singleton',
        'ManifestVersion': '1.6.0',
    }
    # JSON is valid YAML 1.2, avoiding a runtime PyYAML dependency in release CI.
    (assets / 'SunJiao.FlutRenamer.yaml').write_text(json.dumps(winget, indent=2) + '\n')
    files = sorted(p for p in assets.iterdir() if p.is_file() and p.name != 'SHA256SUMS')
    (assets / 'SHA256SUMS').write_text(''.join(f'{sha256(p)}  {p.name}\n' for p in files))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--assets', type=Path, required=True)
    parser.add_argument('--repository', required=True)
    parser.add_argument('--tag', required=True)
    args = parser.parse_args()
    generate(args.assets, args.repository, args.tag)
