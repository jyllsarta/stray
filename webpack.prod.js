const merge = require('webpack-merge')
const common = require('./webpack.common.js')

module.exports = merge(common, {
　mode: 'production',
  performance: {
    maxEntrypointSize: 500000,
    maxAssetSize: 500000,
  },
})