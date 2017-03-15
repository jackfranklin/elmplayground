const CopyWebpackPlugin = require('copy-webpack-plugin');
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: './src/App.elm',
  output: {
    library: 'Elm',
    path: path.join(__dirname, 'build'),
    filename: 'js/App.js',
  },
  devServer: {
    inline: true,
  },
  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack-loader',
    }],
  },
  plugins: [
    new CopyWebpackPlugin([
      {
        from: 'style.css',
      },
      {
        from: 'img/*',
      },
      {
        from: 'js/*',
      },
      {
        from: 'vendor/**/*',
      },
      {
        from: 'content/**/*',
      },
      {
        from: 'index.html',
      }
    ])
  ],
};
