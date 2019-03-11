const {series} = require('gulp');
const {createScratchOrg} = require('./createScratchOrg');
const {deploy} = require('./deploy');

exports = Object.assign(exports, {
  createScratchOrg: createScratchOrg,
  deploy: deploy,
  dev: series(createScratchOrg, deploy)
});