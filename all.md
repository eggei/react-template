webpack.config

```js
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
```

Dockerfile

```
# First Stage: Builder
FROM node:13.12.0-alpine AS client-build
LABEL maintainer="ReactTemplate - Admin <dev@admin.com>"
COPY package*.json ./
RUN npm install && mkdir /react-template && mv ./node_modules ./react-template
WORKDIR /react-template
COPY . .
RUN node_modules/webpack/bin/webpack.js --mode production

# Second Stage: Serve the built code via nginx
FROM nginx:alpine
COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=client-build /react-template/build /usr/share/nginx/html
EXPOSE 3000:8000
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
```

package.json

```json
{
  "name": "react-template",
  "version": "1.0.0",
  "description": "React starter template with webpack and docker configuration.",
  "license": "",
  "repository": {},
  "scripts": {
    "start": "./scripts/start.sh",
    "build": "./scripts/build.sh",
    "docker:build": "./scripts/docker.build.sh",
    "docker:run": "./scripts/docker.run.sh",
    "docker:stop": "docker stop template-test",
    "eslint:check": "./node_modules/eslint/bin/eslint.js . --ext js,jsx --format codeframe",
    "eslint:fix": "./node_modules/eslint/bin/eslint.js . --ext js,jsx --fix --format codeframe",
    "prettier:check": "./node_modules/prettier/bin-prettier.js --list-different \"./**/*.{json,js,jsx}\"",
    "prettier:fix": "./node_modules/prettier/bin-prettier.js --list-different \"./**/*.{json,js,jsx}\" --write",
    "css:check": "./node_modules/stylelint/bin/stylelint.js .",
    "css:fix": "./node_modules/stylelint/bin/stylelint.js . --fix",
    "lint": "npm run prettier:check && npm run eslint:check && npm run css:check",
    "fix": "npm run prettier:fix && npm run eslint:fix && npm run css:fix"
  },
  "dependencies": {
    "react": "^16.13.1",
    "react-dom": "^16.13.1"
  },
  "devDependencies": {
    "@babel/core": "^7.9.0",
    "@babel/plugin-proposal-class-properties": "^7.8.3",
    "@babel/plugin-transform-regenerator": "^7.8.7",
    "@babel/plugin-transform-runtime": "^7.9.0",
    "@babel/preset-env": "^7.9.5",
    "@babel/preset-react": "^7.9.4",
    "babel-eslint": "^10.1.0",
    "babel-loader": "^8.1.0",
    "babel-preset-react-app": "^9.1.2",
    "css-loader": "^3.2.0",
    "eslint": "^6.8.0",
    "eslint-config-airbnb": "^18.0.1",
    "eslint-config-airbnb-base": "^14.0.0",
    "eslint-config-prettier": "^6.10.1",
    "eslint-plugin-cypress": "^2.8.1",
    "eslint-plugin-html": "^6.0.2",
    "eslint-plugin-import": "^2.18.2",
    "eslint-plugin-json": "^2.1.1",
    "eslint-plugin-jsx-a11y": "^6.2.3",
    "eslint-plugin-prettier": "^3.1.3",
    "eslint-plugin-react": "^7.16.0",
    "eslint-plugin-react-hooks": "^1.7.0",
    "html-loader": "^1.1.0",
    "html-webpack-plugin": "^4.2.0",
    "prettier": "2.0.4",
    "react-hot-loader": "^4.12.20",
    "style-loader": "^1.0.0",
    "stylelint": "^11.1.1",
    "stylelint-config-recommended": "^3.0.0",
    "stylelint-order": "^3.1.1",
    "stylelint-scss": "^3.11.1",
    "webpack": "^4.42.1",
    "webpack-cli": "^3.3.11",
    "webpack-dev-server": "^3.10.3"
  },
  "prettier": {
    "semi": false,
    "trailingComma": "all",
    "singleQuote": true,
    "tabWidth": 2,
    "printWidth": 80,
    "bracketSpacing": true,
    "jsxBracketSameLine": false,
    "arrowParens": "avoid"
  },
  "stylelint": {
    "extends": ["stylelint-config-recommended"],
    "plugins": ["stylelint-order", "stylelint-scss"],
    "rules": {
      "scss/at-rule-no-unknown": true,
      "at-rule-empty-line-before": [
        "always",
        {
          "ignore": ["after-comment"],
          "except": ["blockless-after-blockless", "first-nested"]
        }
      ],
      "color-hex-case": "lower",
      "color-hex-length": "long",
      "declaration-colon-newline-after": null,
      "declaration-empty-line-before": null,
      "function-url-quotes": "always",
      "no-descending-specificity": null,
      "string-quotes": "single",
      "value-list-comma-newline-after": null
    }
  }
}
```

.stylelintignore

```
/*
!src/
```

.prettierignore

```
node_modules*
build*
package-lock.json
```

.eslintignore

```
node_modules*
build*
package-lock.json
```

.eslintrc.json

```json
{
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": ["airbnb", "prettier", "plugin:react/recommended"],
  "plugins": ["html", "json", "react", "prettier"],
  "globals": {
    "Atomics": "readonly",
    "SharedArrayBuffer": "readonly"
  },
  "parser": "babel-eslint",
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 2018,
    "sourceType": "module"
  },
  "rules": {
    "one-var": 0,
    "no-use-before-define": 0,
    "no-nested-ternary": 0,
    "no-else-return": 0,
    "no-console": 1,
    "no-debugger": 2,
    "linebreak-style": 1,
    "no-unused-vars": 1,
    "function-call-argument-newline": "off",
    "no-plusplus": 0,
    "no-underscore-dangle": 0,
    "react/jsx-indent": [
      0,
      0,
      {
        "checkAttributes": true,
        "indentLogicalExpressions": true
      }
    ],
    "react/no-array-index-key": 0,
    "react/jsx-one-expression-per-line": [
      0,
      {
        "allow": "single-child"
      }
    ],
    "react/prefer-stateless-function": 0,
    "react/jsx-no-useless-fragment": 2,
    "react/jsx-props-no-spreading": 0,
    "react/prop-types": [
      2,
      {
        "skipUndeclared": true
      }
    ],
    "react/no-unused-prop-types": 2,
    "react/static-property-placement": 0,
    "react/destructuring-assignment": 0, // [1, "always"]
    "react/jsx-curly-newline": 0,
    "react/jsx-wrap-multilines": [
      "error",
      {
        "arrow": true,
        "return": true,
        "declaration": true
      }
    ],
    "import/prefer-default-export": 0,
    "prettier/prettier": [
      "error",
      {
        "semi": false,
        "trailingComma": "all",
        "singleQuote": true,
        "tabWidth": 2,
        "printWidth": 80,
        "bracketSpacing": true,
        "jsxBracketSameLine": false,
        "arrowParens": "avoid"
      }
    ]
  }
}
```

.dockerignore

```
node_modules
build
.dockerignore
Dockerfile
Dockerfile.prod
```

.gitignore

```
node_modules
build
```

src/components

src/styles/main.css

```css
@import './normalize.css';
@import url('https://fonts.googleapis.com/css2?family=Rubik:wght@300&display=swap');

:root {
  --yellow: #f5b81e;
  --parliament: #102540;
  --blue: #075d9a;
  --seablue: #76defb;
  --skyblue: #52a8e1;
}

#root {
  height: 100vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family: 'Rubik', sans-serif;
  text-align: center;
  /* background-color: var(--darkblue); */
  background: radial-gradient(
    circle,
    rgba(16, 37, 64, 1) 11%,
    rgba(13, 31, 55, 1) 58%,
    rgba(5, 16, 29, 1) 100%
  );
  color: white;
}

.animated-box {
  content: '';
  background-color: var(--yellow);
  height: 20px;
  width: 20px;
  position: absolute;
  top: 40px;
  right: 40px;
  animation: breathe 2s ease-in-out infinite;
  animation-direction: alternate;
  border-radius: 100%;
}

@keyframes breathe {
  from {
    opacity: 0;
    transform: scale(1);
  }

  to {
    opacity: 0.8;
    transform: scale(4);
  }
}

.color {
  height: 80px;
  width: 64px;
  display: inline-block;
  z-index: 0;
  border-radius: 2px;
}
.blue {
  background-color: var(--blue);
}
.seablue {
  background: var(--seablue);
}
.skyblue {
  background: var(--skyblue);
}
```

src/styles/normalize.css

```css
/* stylelint-disable */
/*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */

/* Document
   ========================================================================== */

/**
 * 1. Correct the line height in all browsers.
 * 2. Prevent adjustments of font size after orientation changes in iOS.
 */

html {
  line-height: 1.15; /* 1 */
  -webkit-text-size-adjust: 100%; /* 2 */
}

/* Sections
       ========================================================================== */

/**
     * Remove the margin in all browsers.
     */

body {
  margin: 0;
}

/**
     * Render the `main` element consistently in IE.
     */

main {
  display: block;
}

/**
     * Correct the font size and margin on `h1` elements within `section` and
     * `article` contexts in Chrome, Firefox, and Safari.
     */

h1 {
  font-size: 2em;
  margin: 0.67em 0;
}

/* Grouping content
       ========================================================================== */

/**
     * 1. Add the correct box sizing in Firefox.
     * 2. Show the overflow in Edge and IE.
     */

hr {
  box-sizing: content-box; /* 1 */
  height: 0; /* 1 */
  overflow: visible; /* 2 */
}

/**
     * 1. Correct the inheritance and scaling of font size in all browsers.
     * 2. Correct the odd `em` font sizing in all browsers.
     */

pre {
  font-family: monospace, monospace; /* 1 */
  font-size: 1em; /* 2 */
}

/* Text-level semantics
       ========================================================================== */

/**
     * Remove the gray background on active links in IE 10.
     */

a {
  background-color: transparent;
}

/**
     * 1. Remove the bottom border in Chrome 57-
     * 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
     */

abbr[title] {
  border-bottom: none; /* 1 */
  text-decoration: underline; /* 2 */
  text-decoration: underline dotted; /* 2 */
}

/**
     * Add the correct font weight in Chrome, Edge, and Safari.
     */

b,
strong {
  font-weight: 900;
}

/**
     * 1. Correct the inheritance and scaling of font size in all browsers.
     * 2. Correct the odd `em` font sizing in all browsers.
     */

code,
kbd,
samp {
  font-family: monospace, monospace; /* 1 */
  font-size: 1em; /* 2 */
}

/**
     * Add the correct font size in all browsers.
     */

small {
  font-size: 80%;
}

/**
     * Prevent `sub` and `sup` elements from affecting the line height in
     * all browsers.
     */

sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
  vertical-align: baseline;
}

sub {
  bottom: -0.25em;
}

sup {
  top: -0.5em;
}

/* Embedded content
       ========================================================================== */

/**
     * Remove the border on images inside links in IE 10.
     */

img {
  border-style: none;
}

/* Forms
       ========================================================================== */

/**
     * 1. Change the font styles in all browsers.
     * 2. Remove the margin in Firefox and Safari.
     */

button,
input,
optgroup,
select,
textarea {
  font-family: inherit; /* 1 */
  font-size: 100%; /* 1 */
  line-height: 1.15; /* 1 */
  margin: 0; /* 2 */
}

/**
     * Show the overflow in IE.
     * 1. Show the overflow in Edge.
     */

button,
input {
  /* 1 */
  overflow: visible;
}

/**
     * Remove the inheritance of text transform in Edge, Firefox, and IE.
     * 1. Remove the inheritance of text transform in Firefox.
     */

button,
select {
  /* 1 */
  text-transform: none;
}

/**
     * Correct the inability to style clickable types in iOS and Safari.
     */

button,
[type='button'],
[type='reset'],
[type='submit'] {
  -webkit-appearance: button;
}

/**
     * Remove the inner border and padding in Firefox.
     */

button::-moz-focus-inner,
[type='button']::-moz-focus-inner,
[type='reset']::-moz-focus-inner,
[type='submit']::-moz-focus-inner {
  border-style: none;
  padding: 0;
}

/**
     * Restore the focus styles unset by the previous rule.
     */

button:-moz-focusring,
[type='button']:-moz-focusring,
[type='reset']:-moz-focusring,
[type='submit']:-moz-focusring {
  outline: 1px dotted ButtonText;
}

/**
     * Correct the padding in Firefox.
     */

fieldset {
  padding: 0.35em 0.75em 0.625em;
}

/**
     * 1. Correct the text wrapping in Edge and IE.
     * 2. Correct the color inheritance from `fieldset` elements in IE.
     * 3. Remove the padding so developers are not caught out when they zero out
     *    `fieldset` elements in all browsers.
     */

legend {
  box-sizing: border-box; /* 1 */
  color: inherit; /* 2 */
  display: table; /* 1 */
  max-width: 100%; /* 1 */
  padding: 0; /* 3 */
  white-space: normal; /* 1 */
}

/**
     * Add the correct vertical alignment in Chrome, Firefox, and Opera.
     */

progress {
  vertical-align: baseline;
}

/**
     * Remove the default vertical scrollbar in IE 10+.
     */

textarea {
  overflow: auto;
}

/**
     * 1. Add the correct box sizing in IE 10.
     * 2. Remove the padding in IE 10.
     */

[type='checkbox'],
[type='radio'] {
  box-sizing: border-box; /* 1 */
  padding: 0; /* 2 */
}

/**
     * Correct the cursor style of increment and decrement buttons in Chrome.
     */

[type='number']::-webkit-inner-spin-button,
[type='number']::-webkit-outer-spin-button {
  height: auto;
}

/**
     * 1. Correct the odd appearance in Chrome and Safari.
     * 2. Correct the outline style in Safari.
     */

[type='search'] {
  -webkit-appearance: textfield; /* 1 */
  outline-offset: -2px; /* 2 */
}

/**
     * Remove the inner padding in Chrome and Safari on macOS.
     */

[type='search']::-webkit-search-decoration {
  -webkit-appearance: none;
}

/**
     * 1. Correct the inability to style clickable types in iOS and Safari.
     * 2. Change font properties to `inherit` in Safari.
     */

::-webkit-file-upload-button {
  -webkit-appearance: button; /* 1 */
  font: inherit; /* 2 */
}

/* Interactive
       ========================================================================== */

/*
     * Add the correct display in Edge, IE 10+, and Firefox.
     */

details {
  display: block;
}

/*
     * Add the correct display in all browsers.
     */

summary {
  display: list-item;
}

/* Misc
       ========================================================================== */

/**
     * Add the correct display in IE 10+.
     */

template {
  display: none;
}

/**
     * Add the correct display in IE 10.
     */

[hidden] {
  display: none;
}
/* stylintlint-enable */
```

src/index.jsx

```js
import React from 'react'
import ReactDOM from 'react-dom'

// For hot reload feature
import './styles/main.css'

function App() {
  return (
    <div className="wrapper">
      <div className="animated-box" />
      <h1>React Template</h1>
      <div className="color blue" />
      <div className="color skyblue" />
      <div className="color seablue" />
    </div>
  )
}

ReactDOM.render(<App />, document.getElementById('root'))
```

scripts/build.sh

```sh
#!/bin/bash

# Check for the node_modules, if exists build the production code, if not prompt the developer

build_script="node_modules/webpack/bin/webpack.js --mode production"

function evaluate {
    if [[ $1 == 'y' ]]; then
        npm install && eval "$build_script"
        exit
    elif [[ $1 == 'n' ]]; then
        echo '> Exited!'
        exit
    else
        echo "> Please type \"n\" (no) or \"y\" (yes) - do you want to install dependencies?"
        read decision
        evaluate $decision
        exit
    fi
}

if [[ ! -d './node_modules' ]]; then
    echo '==============================================='
    echo " Cannot find dependencies (node_modules)"
    echo "> Do you want to install the dependencies for building the production code? (y|n)"
    read decision
    evaluate $decision
else
    eval "$build_script"
    exit
fi
```

scripts/start.sh

```sh
#!/bin/bash

# Check for the node_modules, if exists serve the code in the browser, if not prompt the developer

serve_script="node_modules/webpack-dev-server/bin/webpack-dev-server.js --config ./webpack.config.js --open"

function evaluate {
    if [[ $1 == 'y' ]]; then
        npm install && eval "$serve_script"
        exit
    elif [[ $1 == 'n' ]]; then
        echo '> Exited!'
        exit
    else
        echo "> Please type \"n\" (no) or \"y\" (yes) - do you want to install dependencies?"
        read decision
        evaluate $decision
        exit
    fi
}

if [[ ! -d './node_modules' ]]; then
    echo '==============================================='
    echo " Cannot find dependencies (node_modules)"
    echo "> Do you want to install the dependencies for serving the code in the browser? (y|n)"
    read decision
    evaluate $decision
else
    eval "$serve_script"
    exit
fi
```

scripts/docker.build.sh

```sh
#!/bin/bash

container_name=template-test
container_tag=react-template

# Pass proxy settings in docker build process in needed
docker_build="\
    docker build \
    -t react-template \
    ./ \
"
docker_run="docker run -d --name $container_name -p 8000:80 $container_tag"



    $docker_build
    if [ $? -eq 0 ]; then
        echo "> Done! - \"npm run docker:run\" to run this container."
    else
        echo "> Failed!"
    fi


```

scripts/docker.run.sh

```sh
#!/bin/bash
container_name=template-test
container_tag=react-template

docker_run="docker run -d --name $container_name -p 8000:80 $container_tag"
existing_container=`docker ps -a -f name=$container_name | grep -w $container_name`

function logger {
    if [ $1 -eq 0 ]; then
        echo "=================================================="
        echo
        echo "Container \"$container_name\" is running on \"localhost:8000\""
        echo "Container ID: $2"
        echo
        echo "=================================================="
    else
        echo "> Failed!"
    fi
}

# Check whether there is a container running with the same name
# If so, remove it before docker run
if [[ $existing_container ]]; then
    docker rm -f $container_name
fi

output=$( $docker_run )
logger $? $output
exit

```

public/favicon.ico
public/manifest.json
public/index.html

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>React Starter Template</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
```

.nginx/nginx.conf

```
worker_processes 4;

events { worker_connections 1024; }

http {
    server {
        listen 80;
        root  /usr/share/nginx/html;
        include /etc/nginx/mime.types;

        location /appui {
            try_files $uri /index.html;
        }
    }
}
```
