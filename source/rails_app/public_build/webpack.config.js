const path = require('path');
const webpack = require('webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
  mode: 'development',
  entry: {
    app: './src/app.js'
  },
  output: {
    path: path.join(__dirname, "..", "public", "dist"),
    filename: "[name]-[hash].bundle.js",
  },
  plugins: [
    new CleanWebpackPlugin(['dist'], {
      root: path.join(__dirname, "..", "public")
    }),
  ],
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  watchOptions: {
    aggregateTimeout: 300,
    poll: 1000,
    ignored: ['node_modules'],
  }
}