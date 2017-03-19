const CopyWebpackPlugin = require('copy-webpack-plugin');
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: [
    './src/App.elm',
    './src/js/app.js',
  ],
  output: {
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
      loader: 'elm-webpack-loader' +
        (process.env.NODE_ENV !== 'production' ? '?+debug' : ''),
    }],
  },
  plugins: [
    new webpack.ProvidePlugin({
      hljs: path.join(__dirname, './vendor/highlight.pack.js'),
    }),
    new CopyWebpackPlugin([
      {
        from: 'style.css',
      },
      {
        from: 'img/*',
      },
      {
        from: 'vendor/**/*.css',
      },
      {
        from: 'content/**/*',
      },
      {
        from: 'index.html',
      },
    ]),
  ],
};
