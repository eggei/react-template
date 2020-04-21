const HtmlWebPackPlugin = require('html-webpack-plugin')
const path = require('path')
const fs = require('fs')

const appDirectory = fs.realpathSync(process.cwd())
const resolveAppPath = relativePath => path.resolve(appDirectory, relativePath)
const host = process.env.HOST || 'localhost'
// Required for babel-preset-react-app
process.env.NODE_ENV = 'development'

module.exports = {
  mode: 'development',
  entry: resolveAppPath('src'),
  output: {
    path: path.join(__dirname, '/build'),
    filename: 'bundle.js',
  },
  devServer: {
    contentBase: resolveAppPath('public'),
    compress: true,
    hot: true,
    port: 3000,
    publicPath: '/',
    historyApiFallback: true,
    host,
  },
  plugins: [
    new HtmlWebPackPlugin({
      template: resolveAppPath('public/index.html'),
      inject: true,
    }),
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.png'],
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        include: resolveAppPath('src'),
        use: {
          loader: 'babel-loader',
          options: {
            // Preset includes JSX, Typescript, and some ESnext features
            // maintained by the Create React App team.
            presets: ['react-app'],
            // Use below when using typescript
            // presets: [["react-app", { "flow": false, "typescript": true }]]
            cacheDirectory: true,
          },
        },
      },
      {
        test: /\.(js|jsx)$/,
        use: 'react-hot-loader/webpack',
        include: /node_modules/,
      },
      {
        test: /\.html$/,
        use: [
          {
            loader: 'html-loader',
          },
        ],
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(png|jpe?g|gif)$/i,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'images/',
            },
          },
        ],
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf|svg)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'fonts/',
            },
          },
        ],
      },
    ],
  },
}