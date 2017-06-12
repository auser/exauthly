import * as React from 'react'
// import styled from 'styled-components'

import Header from '../components/header/Header'

const CoreLayout = Wrapped => props => {
  return (
    <div>
      <Header {...props} />
      <Wrapped {...props} />
    </div>
  )
}

export default CoreLayout
