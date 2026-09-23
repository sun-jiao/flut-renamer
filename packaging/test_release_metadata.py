import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from release_metadata import generate


class ReleaseMetadataTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.assets = Path(self.temp.name)
        (self.assets / 'flut-renamer.exe').write_bytes(b'windows test artifact')
        (self.assets / 'flut-renamer.dmg').write_bytes(b'macos test artifact')
        (self.assets / 'linux.deb').write_bytes(b'linux test artifact')

    def test_manifests_reference_actual_assets_and_repository(self):
        generate(self.assets, 'example/fork', 'v1.2.3')
        scoop = json.loads((self.assets / 'flut-renamer.json').read_text())
        winget = json.loads((self.assets / 'SunJiao.FlutRenamer.yaml').read_text())
        exe = self.assets / 'flut-renamer.exe'
        digest = hashlib.sha256(exe.read_bytes()).hexdigest()
        url = 'https://github.com/example/fork/releases/download/v1.2.3/flut-renamer.exe'
        self.assertEqual(scoop['architecture']['64bit'], {'url': url, 'hash': digest})
        self.assertEqual(winget['Installers'][0]['InstallerUrl'], url)
        self.assertEqual(winget['Installers'][0]['InstallerSha256'], digest.upper())
        self.assertEqual(winget['PackageVersion'], scoop['version'])
        self.assertIn('version "1.2.3"', (self.assets / 'flut-renamer.rb').read_text())
        self.assertIn(hashlib.sha256((self.assets / 'flut-renamer.dmg').read_bytes()).hexdigest(),
                      (self.assets / 'flut-renamer.rb').read_text())
        sums = (self.assets / 'SHA256SUMS').read_text().splitlines()
        self.assertEqual(len(sums), 6)
        for line in sums:
            checksum, name = line.split('  ')
            self.assertEqual(checksum, hashlib.sha256((self.assets / name).read_bytes()).hexdigest())
        generate(self.assets, 'example/fork', 'v1.2.3')
        self.assertEqual(sums, (self.assets / 'SHA256SUMS').read_text().splitlines())

    def test_suffix_tag_preserves_manifest_versions_and_download_urls(self):
        tag = 'v1.6.3-new-packages-test'
        generate(self.assets, 'example/fork', tag)
        scoop = json.loads((self.assets / 'flut-renamer.json').read_text())
        winget = json.loads((self.assets / 'SunJiao.FlutRenamer.yaml').read_text())
        url = f'https://github.com/example/fork/releases/download/{tag}/flut-renamer.exe'
        self.assertEqual(scoop['architecture']['64bit']['url'], url)
        self.assertEqual(winget['Installers'][0]['InstallerUrl'], url)
        self.assertEqual(scoop['version'], tag[1:])
        self.assertEqual(winget['PackageVersion'], tag[1:])
        cask = (self.assets / 'flut-renamer.rb').read_text()
        self.assertIn(f'/releases/download/{tag}/flut-renamer.dmg', cask)
        self.assertIn(f'version "{tag[1:]}"', cask)

    def test_missing_asset_fails_before_writing_manifests(self):
        (self.assets / 'flut-renamer.exe').unlink()
        with self.assertRaises(FileNotFoundError):
            generate(self.assets, 'example/fork', 'v1.2.3')
        self.assertFalse((self.assets / 'flut-renamer.rb').exists())

    def test_rejects_unsupported_or_injected_versions(self):
        for tag in ['v1.2', 'v1.2.3-', 'v1.2.3-test/invalid', 'v1.2.3\nmalicious', 'v1.2.3"']:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                generate(self.assets, 'example/fork', tag)
        with self.assertRaises(ValueError):
            generate(self.assets, 'example/"#{injected}"', 'v1.2.3')


if __name__ == '__main__':
    unittest.main()
