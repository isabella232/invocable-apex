const sfdxjs = require('sfdx-js');
const sfdxprebuilt = require('sfdx-prebuilt');
const sfdx = sfdxjs.Client.createUsingPath(sfdxprebuilt.path);
const argv = require('yargs').argv;

const PERMSET_NAME = 'Speedbit_console_access';

const permset = async () => {
  if(!argv.alias) return Promise.reject('Please specify an alias with --alias NAME');
  let alias = argv.alias;
  try {
    const results = await sfdx.user.permsetAssign({
      permsetname: PERMSET_NAME,
      targetusername: alias,
      json: true
    });
    return Promise.resolve();
  } catch (e) {
    return Promise.reject(e.message);
  }
}

exports.permset = permset;