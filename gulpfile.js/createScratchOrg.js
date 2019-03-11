const path = require('path');
const sfdxjs = require('sfdx-js');
const sfdxprebuilt = require('sfdx-prebuilt');
const sfdx = sfdxjs.Client.createUsingPath(sfdxprebuilt.path);
const argv = require('yargs').argv;

const definitionfile = path.resolve(__dirname, '../config/project-scratch-def.json');

const createScratchOrg = async () => {
  if(!argv.alias) return Promise.reject('Please specify an alias with --alias NAME');
  let alias = argv.alias;
  try {
    const response = await sfdx.org.create({
      definitionfile: definitionfile,
      setalias: alias,
      durationdays: 30,
      json: true
    });
    console.log(`Created scratch org ${response.result.orgId} with username ${response.result.username}`);
    return Promise.resolve();
  } catch (err) {
    err = JSON.parse(err);
    return Promise.reject(err.message);
  }
}

exports.createScratchOrg = createScratchOrg;