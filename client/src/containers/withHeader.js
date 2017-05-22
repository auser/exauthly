import React from 'react'
import Header from '../components/Header/Header'

export const withHeader = Wrapped => props => {

  return (
    <div className='header'>
      <Header {...props} />
      <div className='content'>
        <Wrapped {...props} />
      </div>
    </div>
  )
}

export default withHeader