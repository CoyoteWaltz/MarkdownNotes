# Learn Webpack theory

learn from https://github.com/dykily/simple_webpack

and YouTube [Build your own bundler](https://www.youtube.com/watch?v=Gc9-7PBqOC8&list=LLHK1mTHpwrUeYgF5gu-Kd4g)

And from tomotoes's [blog](https://tomotoes.com/blog/webpack-flight-manual/)

## What is a bundler

A bundler lets us write modules in the processing of programming. Bundle all the modules into one single chunk JS file.

So before we start, we need to be clear about **_Module_**.

## Webpack

_A static module bundler_

### Concepts

Everything can be set in `webpack.config.js`. This file exports a config which tells webpack how to bundle files starting from the entry.

Webpack views every file as a module.

#### Dependency graph

Data structure graph for dependencies in the whole project starting with the entry file(s).

#### Entry

By default its value is `./src/index.js`.

Or specify it in `webpack.config.js`

```js
module.exports = {
  entry: "./path/to/my/entry/file.js",
};
```

#### Output

Property telling webpack where to emit the bundles.

By default its value is `./dist/main.js`

```js
const path = require("path");
module.exports = {
  entry: "./path/to/my/entry/file.js",
  output: {
    path: path.resolve(__direname, "dist"),
    filename: "my-webpack.bundle.js",
  },
};
```

#### Loaders

Since webpack only understands JS and JSON file. **Loaders** tells webpack how to process other types of files and convert them into valid modules.

Loaders has two properties: `test` (**regex** to match filename pattern), `use` (which loader to use)

```javascript
const path = require("path");

module.exports = {
  output: {
    filename: "my-first-webpack.bundle.js",
  },
  // loaders must defined in module.rules
  module: {
    rules: [{ test: /\.txt$/, use: "raw-loader" }],
  },
};
```

#### Plugins

Performing a wide range of tasks like bundle optimization, asset management and injection of environment variables.

```javascript
const HtmlWebpackPlugin = require("html-webpack-plugin"); //installed via npm
const webpack = require("webpack"); //to access built-in plugins

module.exports = {
  module: {
    rules: [{ test: /\.txt$/, use: "raw-loader" }],
  },
  // put in plugins array
  plugins: [
    // for customize the option, you need to create an instance
    new HtmlWebpackPlugin({ template: "./src/index.html" }),
  ],
};
```

#### Mode

Invoking webpack's **built-in optimizations** when setting `development`, `production` or `none` to `mode`.

And will set `process.env.NODE_ENE` on `DefinePlugin` to corresponding value.

#### Browser Compatibility

**Please take time to see [shimming](https://webpack.js.org/guides/shimming/) for using polyfill!**

Further reading: [tree-shaking](https://webpack.js.org/guides/tree-shaking/) for deleting unused code (in static structure import or export).

#### Modules

In modular programming, developers break programs up into **discrete** chunks of functionality called a _module_.

Webpack modules (can express their dependencies in a variety of ways):

- ES6 `import`
- CommonJS `require()`
- AMD `define` and `require`
- `@import` inside a css/sass/less file
- An image url in a stylesheet `url(...)` or HTML `<img src=... >`

Webpack supports multiple types of languages and preprocessors, via **loaders**.

Loaders describe to webpack how to process non-JS modules and include these dependencies into your bundles. See the [**the list of loaders**](https://webpack.js.org/loaders) or write your own.

Modules APIs doc: https://webpack.js.org/api/module-methods/

### Assets Management

**Dynamically bundle** all dependencies (assets).

#### Loading css

```js
// index.js
import './style.css';
// webpack.config.js
...
module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
...
```

```css
/* style.css */
body {
  background-color: #efadfc;
}
```

After build, in the `bundle.js` you can find code snippet like:

```js
eval(
  '// Imports\nvar ___CSS_LOADER_API_IMPORT___ = __webpack_require__(/*! ../node_modules/css-loader/dist/runtime/api.js */ "./node_modules/css-loader/dist/runtime/api.js");\nexports = ___CSS_LOADER_API_IMPORT___(false);\n// Module\nexports.push([module.i, "body {\\n  background-color: #efadfc;\\n}", ""]);\n// Exports\nmodule.exports = exports;\n\n\n//# sourceURL=webpack:///./src/style.css?./node_modules/css-loader/dist/cjs.js'
);
```

I have no idea what is this, but that JS code dynamically generate a `<style>` tag in `<head>`. That's cool!

#### Loading Images

You can `import` image in js file or use `url(...)` in css.

```js
import Img from "./123.jpg"; // Img is a path

myImg.src = Img;
myImg.width = "300";
box.appendChild(myImg);
```

In webpack.config.js

```js
// module.rules:
{
  test: /\.(jpg|svg|png|gif|jpeg)$/,
  use: ['file-loader'],
},
// ...
```

The processed image in `dist/` is minified and optiomized.

#### Loading fonts

Also use `file-loader`

```js
{
	test: /\.(woff|woff2|eot|ttf|otf)$/,
	use: [
		'file-loader',
	],
}
```

In css:

```css
@font-face {
  font-family: "MyFont";
  src: url("./my-font.woff2") format("woff2"), url("./my-font.woff") format("woff");
  font-weight: 600;
  font-style: normal;
}

.hello {
  color: red;
  font-family: "MyFont";
  background: url("./icon.png");
}
```

#### Global Assets

Group your assets with code in a (component) directory.

### Output Management

Use `html-webpack-plugin` to generate an `index.html` which will include all bundles with on worry about their names to reference.

#### Cleaning up the `/dist` folder

Use `clean-webpack-plugin`.

### Development

#### Source map

How can I debug in a bundled file **in development mode**?

Source map: map bundled code to source code.

Add devtool `inline-source-map` in `webpack.config.js`

```js
  devtool: 'inline-source-map', // or 'source-map' this will generate .map json file
```

From this [article](https://blog.teamtreehouse.com/introduction-source-maps), we can know that Chrome and Firefox have source map built-in. You can config the settings in chrome dev tool `Enable JavaScript source map` `Enable CSS source map`. Only you enable the functions in dev tool, you can debug nicely.

#### Watch mode

It quickly becomes a hassle to manually run `npm run build` every time you want to compile your code.

Simply add npm script `"watch": "webpack --watch"`.

And don't clean `index.html` file after incremental build triggered by watch.

```js
// plugins
new CleanWebpackPlugin({ cleanStaleWebpackAssets: false }),
```

The only downside is that you have to refresh your browser in order to see the changes.

#### Using webpack-dev-server

`yarn add --dev webpack-dev-server`

And add in config:

```js
devServer: {
  contentBase: path.join(__dirname, 'dist'),
  port: 8080,
  hot: true,
  inline: true, // reload when file changes
  historyApiFallback: true, // fallback to index.html when missing other files
},
```

This tells `webpack-dev-server` to serve the files from `dist` directory on `localhost:8080`.

_webpack-dev-server doesn't write any output files after compiling. Instead, **it keeps bundle files in memory** and serves them as if they were real files mounted at the server's root path._

If you want your bundle files being referenced in `index.html` at other path like `http://localhost:8080/assets/bundle.js`, config `devServer.publicPath: '/assets/'` . Remember the value should be **surrounded with 2 slashes** or a full URL.

_It is recommended that_ `devServer.publicPath` _is the same as_ [`output.publicPath`](https://webpack.js.org/configuration/output/#outputpublicpath)_._

More detail about dev-server is at https://webpack.js.org/configuration/dev-server/.

Add npm script `"start": "webpack-dev-server --open",`

### Code splitting

This feature allows you to split your code into various bundles which can be loaded on demand or in parallel.

There are three general approaches to code splitting available:

- Entry Points: Manually split code using `entry` configuration.
- Prevent Duplication: Use the `SplitChunksPlugin` to _dedupe_ and split chunks. (dedupe: de-duplication?)
- Dynamic Imports: Split code via inline function calls within modules.

#### Entry Points

Split your code into another module. There are two pitfalls to this approach:

- Duplicated modules will be included in each bundles.
- Not flexible.

#### Prevent duplication

The `dependOn` option allows to share the modules between the chunks.

`dependOn: 'module-name'`, `'module-name': Array | String`

```js
entry: {
  index: { import: './src/index.js', dependOn: 'shared' },
  polyfills: './src/polyfills.js',
  hello: { import: './src/hello.js', dependOn: 'shared' },
  shared: 'lodash',		// shared
},
```

`SplitChunksPlugin` more details in [`SplitChunksPlugin`](https://webpack.js.org/plugins/split-chunks-plugin/)_._

```js
optimization: {
  splitChunks: {
    chunks: 'all'
  }
},
```

#### Dynamic imports

Use `import()` syntax infrom ES module.

Add `chunkFilename` in `output`:

```js
output: {
  filename: '[name].bundle.js',
  chunkFilename: '[name].bundle.js',
  path: path.resolve(__dirname, './dist'),
},
```

And add comment at `import()`: `/* webpackChunkName: "chunkName" */` (single quote is also ok)

```js
async function getComponent() {
  const { default: _ } = await import(
    /* webpackChunkName: 'lodash' */ "lodash"
  ).catch((err) => console.log("error"));
  // ...
}
```

After build, you can see a vendor file in `dist/`. (vendors~lodash.bundle.js)

#### Prefetching/Preloading modules

webpack 4.6.0+

Tell the browser that for:

- prefetch: resource is probably needed for some navigation in the future
- preload: resource might be needed during the current navigation

You should be familiar with `<link>` tag in HTML.

**prefetch**

```js
//...
import(/* webpackPrefetch: true */ "LoginModal");
```

**Preload** directive has a bunch of differences compared to prefetch:

- A preloaded chunk starts loading in parallel to the parent chunk. **A prefetched chunk starts after the parent chunk finishes loading.**
- A preloaded chunk has medium priority and is instantly downloaded. A prefetched chunk is downloaded while the browser is idle.
- A preloaded chunk should be instantly requested by the parent chunk. A prefetched chunk can be used anytime in the future.
- Browser support is different.

### Lazy Load

Use webpackChunkname to dynamically import module.

**So, `webpackChunkName` comment is just an indicator which tells webpack to emit a file with name.**

### Cache

Files produced by webpack compilation can remain cached unless their content has changed.

#### Output Filenames

In filename of output, we can use bracketed strings called **substitutions** to template the filename.

`[name].[contenthash].js`

### Resolve

**`resolve`**

`alias`

```js
const path = require('path');

module.exports = {
  //...
  resolve: {
    alias: {
      Utilities: path.resolve(__dirname, 'src/utilities/'),
      Templates: path.resolve(__dirname, 'src/templates/')
    }
  }
};

// use
import Utility form 'Utilities/utility';
```

A trailing `$` can be added to keys to signify an **exact** match:

```js
const path = require("path");

module.exports = {
  //...
  resolve: {
    alias: {
      xyz$: path.resolve(__dirname, "path/to/file.js"),
    },
  },
};
//
import Test1 from "xyz"; // Exact match, so path/to/file.js is resolved and imported
import Test2 from "xyz/file.js"; // Not an exact match, normal resolution takes place: node_modules/xyz/file.js
```

`extensions`

```js
module.exports = {
  //...
  resolve: {
    extensions: [".wasm", ".mjs", ".js", ".json"],
  },
};
// so you can import those files without extension
import file from "../path/to/file";
```

## Tips & Extension

### Enable ES module

If you need to use `import`(ES module) in nodejs without any translator like babel, you should add `"type": "module"` in your `package.json`. However, `require` is not allowed at that time.

See detail at https://nodejs.org/api/esm.html#esm_package_json_type_field

Note: **Files ending with `.js` will be loaded as ES modules when the nearest parent `package.json` file has `"type": "module"`**

### npm-package.json-pravite

This package will not be published to npm registry.

### npm install --save-dev

_When installing a package that will be bundled into your production bundle, you should use_ `npm install --save`_. If you're installing a package for development purposes (e.g. a linter, testing libraries, etc.) then you should use_ `npm install --save-dev`_._

### Node.js Module

https://nodejs.org/api/modules.html

### AggressiveSplittingPlugin & HTTP2

Further reading: _AggressiveSplittingPlugin_ with HTTP2 to optimize single big chunk js file https://medium.com/webpack/webpack-http-2-7083ec3f3ce6
