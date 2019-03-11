const sfdxjs = require('sfdx-js');
const sfdxprebuilt = require('sfdx-prebuilt');
const sfdx = sfdxjs.Client.createUsingPath(sfdxprebuilt.path);
const argv = require('yargs').argv;

const formatDeployErrors = (err) => {
  let outputErrors = "";
  try {
    if(err.result) {
      errors = err.result;
      if(!err.result.length > 0) errors = [err.result];
      errors.forEach(error => {
        outputErrors += (`Error: ${error.error} in ${error.filePath}\n`)
      });
    }
  } catch (e) {
    // Most likely the JSON.parse of the error failed...
    outputErrors = 'Error while deploying (unrecognized error format): ' + err;
  } finally {
    return outputErrors;
  }

}

const deploy = async () => {
  if (!argv.alias) return Promise.reject('Please specify an alias with --alias NAME');
  let alias = argv.alias;
  try {
    const results = await sfdx.source.push({
      targetusername: alias,
      json: true
    });
    return Promise.resolve();
  } catch (error) {
    error = JSON.parse(error);
    return Promise.reject(new Error(formatDeployErrors(error)));
  }
}

exports.deploy = deploy;