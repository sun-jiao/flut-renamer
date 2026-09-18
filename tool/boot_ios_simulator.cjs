// Select an installed runtime instead of relying on a runner's iPhone name.
// The job owns this fresh simulator; its UDID is also used for cleanup.
const {execFileSync} = require('node:child_process');
const {appendFileSync} = require('node:fs');
if (process.env.GITHUB_ACTIONS !== 'true' || process.env.RUNNER_ENVIRONMENT !== 'github-hosted') {
  throw new Error('Only disposable GitHub-hosted runners are supported.');
}
const inventory = JSON.parse(execFileSync('xcrun', ['simctl', 'list', '--json'], {encoding: 'utf8'}));
const runtimes = inventory.runtimes.filter(r => r.isAvailable && r.identifier.includes('.iOS-'))
  .sort((a, b) => b.version.localeCompare(a.version, undefined, {numeric: true}));
let selection;
for (const runtime of runtimes) {
  const device = (inventory.devices[runtime.identifier] || []).find(d => d.isAvailable && d.name.startsWith('iPhone'));
  const type = device && (device.deviceTypeIdentifier || inventory.devicetypes.find(t => t.name === device.name)?.identifier);
  if (type) { selection = {runtime, type}; break; }
}
if (!selection) throw new Error('No available iOS runtime with an iPhone device was found.');
const udid = execFileSync('xcrun', ['simctl', 'create', 'RenamerIntegration', selection.type, selection.runtime.identifier], {encoding: 'utf8'}).trim();
// Record before boot so the workflow can clean up even if boot fails.
appendFileSync(process.env.GITHUB_ENV, `RENAMER_SIMULATOR_ID=${udid}\n`);
execFileSync('xcrun', ['simctl', 'boot', udid], {stdio: 'inherit'});
execFileSync('xcrun', ['simctl', 'bootstatus', udid, '-b'], {stdio: 'inherit'});
