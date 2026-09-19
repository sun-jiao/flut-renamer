const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const gradle = fs.readFileSync(path.join(root, 'android/app/build.gradle.kts'), 'utf8');

// Mirrors Flutter tools' AndroidProject._androidNamespacePattern. On a clean
// checkout there is no APK from which Flutter can extract the package ID.
const flutterNamespacePattern = /android {[\S\s]+namespace\s*=?\s*['"](.+)['"]/;

test('Flutter can discover the namespace before the first Android build', () => {
  const namespace = gradle.match(flutterNamespacePattern)?.[1];
  assert.equal(namespace, 'net.sunjiao.renamer');
  assert.equal(gradle.match(/^\s*applicationId\s*=\s*"([^"]+)"/m)?.[1], namespace);
});

test('regression: a namespace only inside typed configure is not discoverable', () => {
  const typedOnly = 'configure<ApplicationExtension> {\n namespace = "net.sunjiao.renamer"\n}';
  assert.equal(flutterNamespacePattern.test(typedOnly), false);
});
