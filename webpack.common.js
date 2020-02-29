const VueLoaderPlugin = require("vue-loader/lib/plugin")
const path = require('path');

module.exports = {
  entry: './app/javascript/packs/strayLoader.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, './public/packs')
  },
  module: {
      rules: [
        {
          test: /\.vue$/,
          use: [
            {
              loader: "vue-loader",
              options: { sourceMap: true },
            },
          ]
        },
        {
          test: /\.js$/,
          use: [
            {
              loader: "babel-loader",
              options: {
                presets: [
                  "@babel/preset-env"
                ]
              }
            }
          ]
        },
        {
          test: /\.ts$/,
          use: [
            {
              loader: "babel-loader",
              options: {
                presets: [
                  "@babel/preset-env"
                ]
              }
            }
          ]
        },
        {
          test: /\.scss$/,
          use: [
            "vue-style-loader",
            {
              loader: "css-loader",
              options: { sourceMap: true },
            },
            {
              loader: "sass-loader",
              options: { sourceMap: true },
            },
          ],
        },
        { 
            test: /\.pug$/,
            loader: 'pug-plain-loader'
          },
      ]
  },
  plugins: [
    new VueLoaderPlugin()
  ],
  resolve: {
    extensions: [".vue", ".js"],
    alias: {
      "vue$": "vue/dist/vue.esm.js"
    }
  },
}