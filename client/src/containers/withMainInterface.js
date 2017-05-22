import React from 'react'
import Header from '../components/Header/Header'
import Footer from '../components/Footer/Footer'
import Sidebar from '../components/Sidebar/Sidebar'

export const withHeaderFooter = Wrapped => props => {

  return (
    <div className='main_interface'>
      <Sidebar />
      <div className='container'>
        <Header />
        <div className='content'>
          <Wrapped {...props} />
        </div>
        <Footer />
      </div>
    </div>
  )
}

export default withHeaderFooter