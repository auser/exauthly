import React from 'react'
import Sidebar from '../components/Sidebar/Sidebar'

export const withSidebar = Wrapped => props => {

  return (
    <div className='wrapper'>
      <div className='container'>
        <Sidebar />
        <div className='content'>
          <Wrapped {...props} />
        </div>
      </div>
    </div>
  )
}

export default withSidebar