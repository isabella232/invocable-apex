const sfdxjs = require('sfdx-js');
const sfdxprebuilt = require('sfdx-prebuilt');
const sfdx = sfdxjs.Client.createUsingPath(sfdxprebuilt.path);
const argv = require('yargs').argv;

const PACKAGE_ID = '04t1P0000006JKC';

const installCoveo = async () => {
  if(!argv.alias) return Promise.reject('Please specify an alias with --alias NAME');
  let alias = argv.alias;
  try {
    const response = await sfdx.package.install ({
      package: PACKAGE_ID,
      targetusername: alias,
      noprompt: true,
      wait: 10,
      json: true
    });
    if(response.result && response.result && response.result.Status) {
      console.log(`Installed package: ${PACKAGE_ID} with result: ${response.result.Status}`);
    }
    return Promise.resolve();
  } catch (e) {
    return Promise.reject(e.message);
  }
}

exports.installCoveo = installCoveo;