const path = require('path');

module.exports = config => {

  config.module.loaders.push({
    test: /\.(graphql|gql)$/,
    exclude: /node_modules/,
    loader: 'graphql-tag/loader'
  })

  config.resolve.fallback = [...config.resolve.fallback, path.resolve('../src')];
  return config
}