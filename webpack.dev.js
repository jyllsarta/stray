const merge = require('webpack-merge')
const common = require('./webpack.common.js')

module.exports = merge(common, {
  mode: "development",
  devtool: 'inline-source-map',
  devServer: {
    compress: true,
    port: 9000,
    open: true,
    publicPath: '/dist/',   
  },
})