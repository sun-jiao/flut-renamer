const {test} = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {spawnSync} = require('node:child_process');
const installer = path.join(__dirname, 'install_android_sdk.sh');

function run(t, mode = 'success') {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'sdk-installer-test-'));
  t.after(() => fs.rmSync(root, {recursive: true, force: true}));
  const sdk = path.join(root, 'sdk with spaces');
  const calls = path.join(root, 'calls.jsonl');
  const mock = path.join(root, 'mock.cjs');
  fs.writeFileSync(mock, `
    const fs = require('node:fs');
    const path = require('node:path');
    const args = process.argv.slice(2);
    fs.appendFileSync(process.env.TEST_CALLS, JSON.stringify(args) + '\\n');
    const mode = process.env.TEST_MODE;
    if (args.includes('cmdline-tools;23.0')) process.exit(mode === 'bootstrap-fail' ? 41 : 0);
    if (args.includes('--version')) { console.log('1.0.16261425 (Android CLI)'); process.exit(0); }
    const rootArg = args.find(a => a.startsWith('--sdk='));
    if (!rootArg || args.includes('--channel=0') || args.some(a => a.includes('platforms;'))) process.exit(99);
    if (args.includes('list')) {
      console.log('  platforms/android-37.0     2.0.0     Android SDK Platform 37.0');
      process.exit(mode === 'list-fail' ? 42 : 0);
    }
    if (args.includes('install')) {
      if (args.at(-1) !== 'platforms/android-37.0') process.exit(98);
      if (mode === 'install-fail') process.exit(43);
      if (mode !== 'missing-jar') {
        const target = path.join(rootArg.slice(6), 'platforms/android-37.0');
        fs.mkdirSync(target, {recursive: true});
        fs.writeFileSync(path.join(target, 'android.jar'), 'test placeholder');
      }
      process.exit(0);
    }
    process.exit(97);
  `);
  const shellQuote = s => "'" + s.replaceAll("'", "'\\''") + "'";
  for (const name of ['latest/bin/sdkmanager', '23.0/bin/android']) {
    const binary = path.join(sdk, 'cmdline-tools', name);
    fs.mkdirSync(path.dirname(binary), {recursive: true});
    fs.writeFileSync(binary, `#!/usr/bin/env bash\nexec ${shellQuote(process.execPath)} ${shellQuote(mock)} "$@"\n`, {mode: 0o755});
  }
  const result = spawnSync('bash', [installer], {
    cwd: root,
    encoding: 'utf8',
    timeout: 10000,
    env: {...process.env, ANDROID_HOME: sdk, ANDROID_SDK_ROOT: '',
      GITHUB_PATH: path.join(root, 'github-path'), TEST_MODE: mode, TEST_CALLS: calls},
  });
  assert.equal(result.error, undefined);
  return {result, root, calls: fs.readFileSync(calls, 'utf8').trim().split('\n').map(JSON.parse)};
}

test('new CLI slash-separated table does not cause a false missing-package failure', t => {
  const {result, root, calls} = run(t);
  assert.equal(result.status, 0, result.stderr);
  assert.ok(calls.some(c => c.includes('install') && c.at(-1) === 'platforms/android-37.0'));
  assert.match(fs.readFileSync(path.join(root, 'integration-sdk-packages.log'), 'utf8'), /platforms\/android-37\.0/);
  assert.doesNotMatch(result.stderr, /Broken pipe/);
});
for (const [mode, code] of [['bootstrap-fail', 41], ['list-fail', 42], ['install-fail', 43]]) {
  test(`${mode} preserves the installer exit status`, t => {
    const {result, calls} = run(t, mode);
    assert.equal(result.status, code, result.stderr);
    if (mode !== 'install-fail') assert.ok(!calls.some(c => c.includes('install')));
  });
}
test('successful installer without android.jar is still a failure', t => {
  const {result} = run(t, 'missing-jar');
  assert.equal(result.status, 1);
  assert.match(result.stderr, /android.jar is missing/);
});
