import React from 'react'
import T from 'prop-types'

function ErrorMessage (props) {
  return (
    <div className='form__error-wrapper js-form__err-animation'>
      <p className='form__error'>
        {props.error}
      </p>
    </div>
  )
}

ErrorMessage.propTypes = {
  error: T.string
}

export default ErrorMessage