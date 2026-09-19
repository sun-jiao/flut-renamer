// Select an installed runtime instead of relying on a runner's iPhone name.
// The job owns this fresh simulator; its UDID is also used for cleanup.
const {execFileSync} = require('node:child_process');
const {appendFileSync} = require('node:fs');
if (process.env.GITHUB_ACTIONS !== 'true' || process.env.RUNNER_ENVIRONMENT !== 'github-hosted') {
  throw new Error('Only disposable GitHub-hosted runners are supported.');
}
const sdkVersion = execFileSync(
  'xcrun', ['--sdk', 'iphonesimulator', '--show-sdk-version'], {encoding: 'utf8'},
).trim();
const inventory = JSON.parse(execFileSync('xcrun', ['simctl', 'list', '--json'], {encoding: 'utf8'}));
const compareVersions = (left, right) => {
  const leftParts = left.split('.').map(Number);
  const rightParts = right.split('.').map(Number);
  for (let index = 0; index < Math.max(leftParts.length, rightParts.length); index += 1) {
    const difference = (leftParts[index] || 0) - (rightParts[index] || 0);
    if (difference !== 0) return difference;
  }
  return 0;
};
const runtimes = inventory.runtimes
  .filter(r => r.isAvailable && r.identifier.includes('.iOS-'))
  // A runner can contain runtimes installed by newer, inactive Xcode versions.
  // CoreSimulator may boot them, but the active Xcode/Flutter toolchain cannot
  // reliably install, launch, or read logs from them.
  .filter(r => compareVersions(r.version, sdkVersion) <= 0)
  .sort((a, b) => b.version.localeCompare(a.version, undefined, {numeric: true}));
let selection;
for (const runtime of runtimes) {
  const device = (inventory.devices[runtime.identifier] || []).find(d => d.isAvailable && d.name.startsWith('iPhone'));
  const type = device && (device.deviceTypeIdentifier || inventory.devicetypes.find(t => t.name === device.name)?.identifier);
  if (type) { selection = {runtime, type}; break; }
}
if (!selection) {
  throw new Error(`No available iOS runtime compatible with the active ${sdkVersion} simulator SDK was found.`);
}
const udid = execFileSync('xcrun', ['simctl', 'create', 'RenamerIntegration', selection.type, selection.runtime.identifier], {encoding: 'utf8'}).trim();
// Record before boot so the workflow can clean up even if boot fails.
appendFileSync(process.env.GITHUB_ENV, `RENAMER_SIMULATOR_ID=${udid}\n`);
execFileSync('xcrun', ['simctl', 'boot', udid], {stdio: 'inherit'});
execFileSync('xcrun', ['simctl', 'bootstatus', udid, '-b'], {stdio: 'inherit'});
