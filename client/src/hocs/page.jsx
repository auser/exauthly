// import { WithAuthorization } from './authorization'
import { compose } from 'redux'
import { withRouter } from 'react-router-dom'

export const page = Wrapped => {
  return withRouter(Wrapped)
}

export default page
