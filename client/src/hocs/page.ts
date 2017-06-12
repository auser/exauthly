import {withAuthentication} from './withAuthentication'
import { compose } from 'redux'
import { withRouter } from 'react-router-dom'

export const Page = Wrapped => {
  return withAuthentication(Wrapped)
}

export default Page
