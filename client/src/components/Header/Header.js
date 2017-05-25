import React from 'react'
import classnames from 'classnames'

import { css } from 'glamor'

const header = css({
  border: '1px solid blue',
  fontSize: 19,
})

export const Header = (props) => {

  return (
    <header {...header}>
      header goes here
    </header>
  )
}

export default Header