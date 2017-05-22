import React from 'react'

import withMainInterface from 'containers/withMainInterface'

export const Centered = props => {
  return (
    <div>
      {props.children}
      ok?
    </div>
  )
}

export default Centered