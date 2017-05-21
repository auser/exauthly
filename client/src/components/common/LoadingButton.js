import React from 'react'
import T from 'prop-types'
import LoadingIndicator from './LoadingIndicator'

function LoadingButton (props) {
  return (
    <a href='#' className={props.className + ' btn btn--loading'} disabled='true'>
      <LoadingIndicator />
    </a>
  )
}

LoadingButton.propTypes = {
  className: T.string
}

export default LoadingButton