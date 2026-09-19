const {test} = require('node:test');
const assert = require('node:assert/strict');
const {readFileSync} = require('node:fs');
const {join} = require('node:path');
const {runInNewContext} = require('node:vm');
const source = readFileSync(join(__dirname, 'boot_ios_simulator.cjs'), 'utf8');

function run(inventory, {env = {}, failBoot = false} = {}) {
  const commands = [];
  const outputs = [];
  const execFileSync = (exe, args) => {
    commands.push([exe, ...args]);
    if (args[0] === '--sdk') return '18.5\n';
    if (args[1] === 'list') return JSON.stringify(inventory);
    if (args[1] === 'create') return 'test-udid\n';
    if (args[1] === 'boot' && failBoot) throw Error('boot failed');
    return '';
  };
  let error;
  try {
    runInNewContext(source, {
      require: name => name === 'node:child_process' ? {execFileSync}
        : {appendFileSync: (...args) => outputs.push(args)},
      process: {env: {GITHUB_ACTIONS: 'true', RUNNER_ENVIRONMENT: 'github-hosted', GITHUB_ENV: '/job/env', ...env}},
    });
  } catch (caught) { error = caught; }
  return {commands, outputs, error};
}
const inventory = {
  runtimes: [
    {identifier: 'runtime.iOS-18-4', version: '18.4', isAvailable: true},
    {identifier: 'runtime.iOS-18-5', version: '18.5', isAvailable: true},
    {identifier: 'runtime.iOS-26', version: '26.0', isAvailable: true},
    {identifier: 'runtime.iOS-27', version: '27.0', isAvailable: false},
  ],
  devices: {
    'runtime.iOS-18-4': [{name: 'iPhone Old', isAvailable: true, deviceTypeIdentifier: 'old'}],
    'runtime.iOS-18-5': [{name: 'iPhone Compatible', isAvailable: true, deviceTypeIdentifier: 'compatible'}],
    'runtime.iOS-26': [{name: 'iPhone New', isAvailable: true, deviceTypeIdentifier: 'new'}],
  },
  devicetypes: [],
};
test('uses the newest runtime supported by the active Xcode SDK', () => {
  const result = run(inventory);
  assert.equal(result.error, undefined);
  assert.deepEqual(result.commands[0], ['xcrun', '--sdk', 'iphonesimulator', '--show-sdk-version']);
  assert.deepEqual(result.commands[2], [
    'xcrun', 'simctl', 'create', 'RenamerIntegration', 'compatible', 'runtime.iOS-18-5',
  ]);
  assert.deepEqual(result.commands.at(-1), ['xcrun', 'simctl', 'bootstatus', 'test-udid', '-b']);
  assert.deepEqual(result.outputs, [['/job/env', 'RENAMER_SIMULATOR_ID=test-udid\n']]);
});
test('falls back to a runtime that has an available iPhone', () => {
  const result = run({
    ...inventory,
    devices: {'runtime.iOS-18-4': inventory.devices['runtime.iOS-18-4']},
  });
  assert.equal(result.commands[2].at(-1), 'runtime.iOS-18-4');
});
test('rejects missing iOS devices rather than launching another platform', () => {
  const result = run({...inventory, devices: {}});
  assert.match(result.error.message, /compatible with the active 18\.5 simulator SDK/);
  assert.equal(result.commands.length, 2);
});
test('refuses local and self-hosted environments before invoking simctl', () => {
  for (const env of [{GITHUB_ACTIONS: 'false'}, {RUNNER_ENVIRONMENT: 'self-hosted'}]) {
    const result = run(inventory, {env});
    assert.match(result.error.message, /Only disposable/);
    assert.deepEqual(result.commands, []);
  }
});
test('rejects runtimes newer than the active Xcode simulator SDK', () => {
  const result = run({
    ...inventory,
    runtimes: inventory.runtimes.filter(runtime => runtime.version.startsWith('26.')),
    devices: {'runtime.iOS-26': inventory.devices['runtime.iOS-26']},
  });
  assert.match(result.error.message, /compatible with the active 18\.5 simulator SDK/);
  assert.ok(!result.commands.some(command => command.includes('create')));
});
test('records owned device for workflow cleanup even when boot fails', () => {
  const result = run(inventory, {failBoot: true});
  assert.match(result.error.message, /boot failed/);
  assert.equal(result.outputs[0][1], 'RENAMER_SIMULATOR_ID=test-udid\n');
});
