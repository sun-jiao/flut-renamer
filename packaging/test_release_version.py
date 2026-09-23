import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from release_version import parse_tag, validate_version


class ReleaseVersionTest(unittest.TestCase):
    def test_stable_and_suffix_tags_match_pubspec_base(self):
        for tag in ['v1.6.3', 'v1.6.3-new-packages-test', 'v1.6.3-rc.1', 'v1.6.3-beta']:
            with self.subTest(tag=tag):
                self.assertEqual(validate_version(tag, 'name: app\nversion: 1.6.3+18\n'), '1.6.3')
                self.assertEqual(parse_tag(tag), ('1.6.3', tag[1:]))

    def test_mismatched_base_still_fails(self):
        with self.assertRaisesRegex(ValueError, 'does not match'):
            validate_version('v1.6.4-test', 'version: 1.6.3+18\n')

    def test_invalid_tags_fail(self):
        for tag in ['1.6.3', 'v1.6', 'v1x6x3', 'v1.6.3-', 'v1.6.3-test..1',
                    'v1.6.3-test/1', 'v1.6.3-test\n', 'v1.6.3-"']:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                parse_tag(tag)

    def test_missing_pubspec_version_fails(self):
        with self.assertRaisesRegex(ValueError, 'Cannot read'):
            validate_version('v1.6.3', 'name: app\n')

    def test_cli_for_reported_release_tag(self):
        root = Path(__file__).resolve().parent.parent
        with tempfile.TemporaryDirectory() as directory:
            pubspec = Path(directory) / 'pubspec.yaml'
            pubspec.write_text('name: app\nversion: 1.6.3+18\n')
            result = subprocess.run(
                [sys.executable, str(root / 'packaging/release_version.py'),
                 '--tag', 'v1.6.3-new-packages-test', '--pubspec', str(pubspec)],
                capture_output=True, text=True,
            )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), '1.6.3')


if __name__ == '__main__':
    unittest.main()
