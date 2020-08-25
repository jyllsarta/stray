const merge = require('webpack-merge')
const common = require('./webpack.common.js')
const SentryWebpackPlugin = require("@sentry/webpack-plugin");

module.exports = merge(common, {
　mode: 'production',
  performance: {
    maxEntrypointSize: 1500000,
    maxAssetSize: 1500000,
  },
  plugins: [
    new SentryWebpackPlugin({
      include: ".",
      ignoreFile: ".sentrycliignore",
      ignore: ["node_modules", "webpack.config.js"],
      configFile: "sentry.properties",
    }),
  ],
})