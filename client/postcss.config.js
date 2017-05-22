module.exports = ctx => {
  return {
    plugins: [
      require('postcss-import')(),
      require('postcss-font-awesome')(),
      require('precss')(),
      require('autoprefixer')({
        "browsers": "> 5%",
      }),
    ]
  }
}
