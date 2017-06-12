import * as React from 'react'

import {
  Redirect
} from 'react-router-dom'

import {connect} from 'react-redux'
import {userLogout} from '../../../redux/modules/auth/actions'

const Logout = (props:any) => {
  setTimeout(props.userLogout, 50)
  return (
    <Redirect to="/" />
  )
}

export default connect(
  null,
  dispatch => ({
    userLogout: () => dispatch(userLogout())
  })
)(Logout)
