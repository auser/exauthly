import * as React from 'react'
import * as classnames from 'classnames'
import styled from 'styled-components'

export const Features = (props:any) => (
  <div className={classnames(props.className)}>
    Things will go here
  </div>
)

export default styled(Features)`
min-height: 150px;
display: flex;
justify-content: center;
align-items: center;
`
