import React from 'react'
import Footer from '../components/Footer/Footer'

export const withFooter = Wrapped => props => {

  return (
    <div className='wrapper'>
      <div className='content'>
        <Wrapped {...props} />
      </div>
      <Footer {...props} />
    </div>
  )
}

export default withFooter