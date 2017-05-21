import initialSetup from './init'

// function runWatchers(watchers) {
//   return Object
//     .values(watchers)
//     .map(watcher => watcher())
// }

export default function* rootSaga() {
  yield [
    initialSetup(),
  ]
}